// lib/screens/goals/goals_master_detail_screen.dart
import 'package:auraflow/models/goal.dart';
import 'package:auraflow/notifiers/goal_notifier.dart';
import 'package:auraflow/screens/goals/goal_detail_screen.dart';
import 'package:auraflow/screens/goals/widgets/goal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';


class GoalsMasterDetailScreen extends StatelessWidget {
  const GoalsMasterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalNotifier>(
      builder: (context, goalNotifier, child) {
        final selectedGoal = goalNotifier.selectedGoal;

        return Row(
          children: [
            SizedBox(
              width: 350,
              child: ValueListenableBuilder<Box<Goal>>(
                valueListenable: goalNotifier.goalsListenable,
                builder: (context, box, _) {
                  final goals = box.values.toList().cast<Goal>();
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return GoalCard(
                        goal: goal,
                        onTap: () => goalNotifier.selectGoal(goal),
                        onDelete: () => _showDeleteGoalConfirmation(context, goalNotifier, goal)
                      );
                    },
                  );
                },
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              child: selectedGoal != null
                  ? GoalDetailScreen(
                      key: ValueKey(selectedGoal.id), 
                      goal: selectedGoal,
                    )
                  : const Center(
                      child: Text("Select a goal to see its details."),
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteGoalConfirmation(BuildContext context, GoalNotifier notifier, Goal goal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Goal?"),
          content: Text(
            'Are you sure you want to permanently delete "${goal.name}"?\n\nThis will also delete all of its tasks. This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
              onPressed: () {
                notifier.deleteGoal(goal);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Goal "${goal.name}" deleted.')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}