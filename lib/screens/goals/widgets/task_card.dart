// lib/screens/goals/widgets/task_card.dart
import 'package:auraflow/models/task.dart';
import 'package:auraflow/models/task_priority.dart';
import 'package:auraflow/notifiers/goal_notifier.dart';
import 'package:auraflow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.taskKey});
  final dynamic taskKey;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isExpanded = false;

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade400;
      case TaskPriority.medium:
        return Colors.orange.shade600;
      case TaskPriority.low:
        return Colors.blue.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksBox = Hive.box<Task>('tasks');

    return ValueListenableBuilder(
      valueListenable: tasksBox.listenable(),
      builder: (context, Box<Task> box, _) {
        final Task? currentTask = box.get(widget.taskKey);
        if (currentTask == null) return const SizedBox.shrink();

        final theme = Theme.of(context);
        // THE FIX: Fetch into a nullable variable without the '!'
        final customColors = theme.extension<AuraFlowCustomColors>();
        final bool isDone = currentTask.isDone;

        // THE FIX: Provide sensible default colors in case the theme extension is null.
        final completedSurfaceColor = customColors?.completedSurface ?? Colors.grey.shade200;
        final cardColor = theme.cardTheme.color ?? Colors.white;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isDone ? completedSurfaceColor : cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDone ? Colors.transparent : theme.dividerColor.withOpacity(0.5),
            ),
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              children: [
                _buildMainTaskTile(context, currentTask),
                if (_isExpanded)
                  _buildSubTaskList(context, currentTask),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainTaskTile(BuildContext context, Task task) {
    final notifier = context.read<GoalNotifier>();
    final theme = Theme.of(context);
    final customColors = theme.extension<AuraFlowCustomColors>();
    final isDone = task.isDone;
    
    // THE FIX: Provide fallback colors for all custom color usages
    final completedOnSurfaceColor = customColors?.completedOnSurface ?? Colors.grey.shade500;
    final cardColor = theme.cardTheme.color ?? Colors.white;

    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Row(
          children: [
            Checkbox(
              value: isDone,
              onChanged: (value) {
                task.isDone = value ?? false;
                notifier.updateTask(task);
              },
              activeColor: completedOnSurfaceColor,
              checkColor: cardColor,
            ),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: TextStyle(
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: isDone ? completedOnSurfaceColor : null,
                      decorationColor: completedOnSurfaceColor,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      if (task.dueDate != null)
                        Text(
                          "Due: ${DateFormat.yMMMd().format(task.dueDate!)}",
                          style: TextStyle(fontSize: 12, color: theme.hintColor),
                        ),
                      
                      Text(
                        "Created: ${DateFormat.yMMMd().format(task.createdAt)}",
                        style: TextStyle(fontSize: 12, color: theme.hintColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (!isDone)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.priority.name.toUpperCase(),
                  style: TextStyle(
                    color: _getPriorityColor(task.priority),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  tooltip: "Delete Task",
                  color: isDone ? completedOnSurfaceColor : theme.iconTheme.color,
                  onPressed: () => _showDeleteConfirmation(context, notifier, task),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: isDone ? completedOnSurfaceColor : theme.hintColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTaskList(BuildContext context, Task task) {
    final notifier = context.read<GoalNotifier>();
    final customColors = Theme.of(context).extension<AuraFlowCustomColors>();
    final completedOnSurfaceColor = customColors?.completedOnSurface ?? Colors.grey.shade500;
    final cardColor = Theme.of(context).cardTheme.color ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          const Divider(),
          for (var subTask in task.subTasks)
            ListTile(
              dense: true,
              leading: Checkbox(
                value: subTask.isDone,
                onChanged: (value) {
                  subTask.isDone = value ?? false;
                  notifier.updateTask(task);
                },
                activeColor: completedOnSurfaceColor,
                checkColor: cardColor,
              ),
              title: Text(
                subTask.name,
                style: TextStyle(
                  decoration: subTask.isDone ? TextDecoration.lineThrough : null,
                  color: subTask.isDone ? completedOnSurfaceColor : null,
                  decorationColor: completedOnSurfaceColor,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.clear, size: 20),
                tooltip: "Delete Sub-task",
                onPressed: () => notifier.deleteSubTask(subTask),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add Sub-task"),
              onPressed: () => _showAddSubTaskDialog(context, notifier, task),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, GoalNotifier notifier, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task?"),
        content: Text('Are you sure you want to permanently delete "${task.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
            onPressed: () {
              context.read<GoalNotifier>().deleteTask(task);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAddSubTaskDialog(BuildContext context, GoalNotifier notifier, Task parentTask) {
    final subTaskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Sub-task"),
        content: TextField(
          controller: subTaskController,
          autofocus: true,
          decoration: const InputDecoration(labelText: "Sub-task Description"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Add"),
            onPressed: () {
              if (subTaskController.text.isNotEmpty) {
                final newSubTask = SubTask(name: subTaskController.text);
                notifier.addSubTaskToTask(parentTask, newSubTask);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}