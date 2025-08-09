// lib/screens/goals/widgets/task_card.dart
import 'package:auraflow/models/task.dart';
import 'package:auraflow/models/task_priority.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onStatusChanged,
    required this.onSubTaskStatusChanged,
    required this.onAddSubTask,
    required this.onDelete,
  });

  final Task task;
  final ValueChanged<bool> onStatusChanged;
  final void Function(SubTask, bool) onSubTaskStatusChanged;
  final VoidCallback onAddSubTask;
  final VoidCallback onDelete;

  Widget _getPriorityIcon(TaskPriority priority, BuildContext context) {
    switch (priority) {
      case TaskPriority.high:
        return Icon(Icons.keyboard_double_arrow_up, color: Colors.red.shade700);
      case TaskPriority.medium:
        return Icon(Icons.keyboard_arrow_up, color: Colors.orange.shade700);
      case TaskPriority.low:
        return Icon(Icons.keyboard_arrow_down, color: Colors.blue.shade700);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isTaskDone = task.isDone;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          color: Colors.red.shade700,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: ExpansionTile(
          leading: Checkbox(
            value: isTaskDone,
            onChanged: (value) => onStatusChanged(value ?? false),
          ),
          title: Text(
            task.name,
            style: TextStyle(
              decoration: isTaskDone ? TextDecoration.lineThrough : null,
              color: isTaskDone ? Colors.grey : theme.textTheme.bodyLarge?.color,
            ),
          ),
          subtitle: task.dueDate != null
              ? Text(
                  "Due: ${DateFormat.yMMMd().format(task.dueDate!)}",
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                )
              : null,
          trailing: _getPriorityIcon(task.priority, context),
          children: [
            for (var subTask in task.subTasks)
              ListTile(
                dense: true,
                leading: Checkbox(
                  value: subTask.isDone,
                  onChanged: (value) => onSubTaskStatusChanged(subTask, value ?? false),
                ),
                title: Text(
                  subTask.name,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: subTask.isDone ? TextDecoration.lineThrough : null,
                    color: subTask.isDone ? Colors.grey : theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Sub-task"),
                onPressed: onAddSubTask,
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}