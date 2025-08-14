// lib/screens/goals/goal_detail_screen.dart
import 'package:auraflow/models/goal.dart';
import 'package:auraflow/models/task.dart';
import 'package:auraflow/models/task_priority.dart';
import 'package:auraflow/notifiers/goal_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:auraflow/screens/goals/widgets/task_card.dart';

/// Displays the details and tasks for a single Goal.
///
/// This screen allows users to view, add, and manage the tasks associated
/// with the goal they selected from the `GoalListScreen`.
class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final goalNotifier = context.read<GoalNotifier>();

    return Scaffold(
      appBar: AppBar(title: Text(goal.name)),

     body: ValueListenableBuilder(
      // CORRECTED: Listen to the 'goals' box. When a Goal is saved
      // (because we added a task to it), this listener will fire.
      valueListenable: Hive.box<Goal>('goals').listenable(),
      builder: (context, Box<Goal> goalBox, _) {
        // IMPORTANT: We still get the tasks from our specific 'goal' object.
        // The listener just tells us WHEN to rebuild.
        final tasks = goal.tasks.toList();

        if (tasks.isEmpty) {
          return const Center(
            child: Text("No tasks for this goal yet.\nTap '+' to add one!"),
          );
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Dismissible(
                      key: Key(task.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        goalNotifier.deleteTask(task);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Task "${task.name}" deleted.')),
                        );
                      },
                      background: Container(
                        color: Colors.red.shade700,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
                      ),
                      child: TaskCard(taskKey: task.key,),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, goal),
        tooltip: 'Add Task',
        child: const Icon(Icons.add_task),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, Goal goal) {
  final taskController = TextEditingController();
  TaskPriority selectedPriority = TaskPriority.medium;
  DateTime? selectedDueDate;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Add New Task"),
            content: SingleChildScrollView( // Prevents overflow on small screens
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: "Task Description"),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<TaskPriority>(
                    value: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: "Priority",
                      border: OutlineInputBorder(),
                    ),
                    items: TaskPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (TaskPriority? newValue) {
                      if (newValue != null) {
                        setDialogState(() => selectedPriority = newValue);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    title: Text(
                      selectedDueDate == null
                          ? 'No Due Date'
                          : 'Due: ${DateFormat.yMMMd().format(selectedDueDate!)}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDueDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                      );
                      if (pickedDate != null) {
                        setDialogState(() => selectedDueDate = pickedDate);
                      }
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("Add"),
                onPressed: () {
                  if (taskController.text.isNotEmpty) {
                    final newTask = Task(
                      name: taskController.text,
                      priority: selectedPriority,
                      dueDate: selectedDueDate, // Pass the selected due date
                    );
                    context.read<GoalNotifier>().addTaskToGoal(goal, newTask);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
}
