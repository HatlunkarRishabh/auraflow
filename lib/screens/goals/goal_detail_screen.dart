// lib/screens/goals/goal_detail_screen.dart
import 'package:auraflow/models/goal.dart';
import 'package:auraflow/models/task.dart';
import 'package:auraflow/notifiers/goal_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, Box<Task> taskBox, _) {
          final tasks = goal.tasks.toList();

          if (tasks.isEmpty) {
            return const Center(
              child: Text("No tasks for this goal yet.\nTap '+' to add one!"),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(
                  task.name,
                  style: TextStyle(
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isDone
                        ? Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withOpacity(0.5)
                        : null,
                  ),
                ),
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (bool? value) {
                    task.isDone = value ?? false;
                    goalNotifier.updateTask(task);
                  },
                ),
                // We'll add a proper delete button later
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => goalNotifier.deleteTask(task),
                  tooltip: 'Delete Task',
                ),
              );
            },
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

  // Shows a dialog to add a new task to the goal.
  void _showAddTaskDialog(BuildContext context, Goal goal) {
    final taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: TextField(
            controller: taskController,
            autofocus: true,
            decoration: const InputDecoration(labelText: "Task Description"),
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
                  final newTask = Task(name: taskController.text);
                  context.read<GoalNotifier>().addTaskToGoal(goal, newTask);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
