import 'package:auraflow/models/goal.dart';
import 'package:auraflow/notifiers/goal_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class GoalListScreen extends StatelessWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalNotifier = context.read<GoalNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Goals"),
      ),
      body: ValueListenableBuilder<Box<Goal>>(
        valueListenable: goalNotifier.goalsListenable,
        builder: (context, box, _) {
          final goals = box.values.toList().cast<Goal>();

          if (goals.isEmpty) {
            return const Center(
              child: Text(
                "No goals yet.\nTap the '+' button to add your first goal!",
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(goal.name),
                  subtitle: LinearProgressIndicator(value: goal.progress),
                  onTap: () {
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        tooltip: 'Add Goal',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final taskController = TextEditingController();
    String colorHex = "FF9E9E9E"; 

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create New Goal"),
          content: TextField(
            controller: taskController,
            autofocus: true,
            decoration: const InputDecoration(labelText: "Goal Name"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Create"),
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  context.read<GoalNotifier>().addGoal(
                        name: taskController.text,
                        colorHex: colorHex,
                      );
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