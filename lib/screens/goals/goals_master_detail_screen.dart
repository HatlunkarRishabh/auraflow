// lib/screens/goals/goals_master_detail_screen.dart
import 'package:auraflow/models/goal.dart';
import 'package:auraflow/notifiers/goal_notifier.dart';
import 'package:auraflow/screens/goals/goal_detail_screen.dart';
import 'package:auraflow/screens/goals/widgets/goal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

/// A master-detail layout for desktop/tablet view of Goals.
///
/// Displays a list of goals on the left pane and the details of the
/// selected goal on the right pane.
class GoalsMasterDetailScreen extends StatelessWidget {
  const GoalsMasterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a Consumer here to get the selectedGoal and rebuild when it changes.
    return Consumer<GoalNotifier>(
      builder: (context, goalNotifier, child) {
        final selectedGoal = goalNotifier.selectedGoal;

        return Row(
          children: [
            // --- MASTER PANE (List of Goals) ---
            SizedBox(
              // Constrain the width of the list pane.
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
                        // When a card is tapped, we update the notifier.
                        onTap: () => goalNotifier.selectGoal(goal),
                      );
                    },
                  );
                },
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            // --- DETAIL PANE (Selected Goal's Details) ---
            Expanded(
              child: selectedGoal != null
                  // If a goal is selected, show its detail screen.
                  ? GoalDetailScreen(
                      key: ValueKey(selectedGoal.id), // Use a key to ensure it rebuilds
                      goal: selectedGoal,
                    )
                  // If no goal is selected, show a placeholder.
                  : const Center(
                      child: Text("Select a goal to see its details."),
                    ),
            ),
          ],
        );
      },
    );
  }
}