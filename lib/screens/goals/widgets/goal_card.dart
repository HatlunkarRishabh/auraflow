// lib/screens/goals/widgets/goal_card.dart
import 'package:auraflow/models/goal.dart';
import 'package:auraflow/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    required this.onDelete,
  });

  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use the null-aware operator '?' instead of '!' for safety.
    final customColors = theme.extension<AuraFlowCustomColors>();
    final goalColor = Color(int.parse(goal.colorHex, radix: 16));
    final progress = goal.progress;
    final isCompleted = progress >= 1.0;

    // Provide default fallback colors if the extension is somehow null.
    final completedSurfaceColor = customColors?.completedSurface ?? Colors.grey.shade200;
    final completedOnSurfaceColor = customColors?.completedOnSurface ?? Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted ? completedSurfaceColor : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isCompleted)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? completedOnSurfaceColor.withOpacity(0.2)
                        : goalColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flag,
                    color: isCompleted ? completedOnSurfaceColor : goalColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    goal.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? completedOnSurfaceColor : null,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      decorationColor: completedOnSurfaceColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete(); // Call the passed-in delete function
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline, color: Colors.red),
                        title: Text('Delete Goal', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                  icon: Icon(Icons.more_vert, color: theme.hintColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: isCompleted
                          ? completedOnSurfaceColor.withOpacity(0.2)
                          : goalColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted ? completedOnSurfaceColor : goalColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? completedOnSurfaceColor : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isCompleted
                  ? "Completed: ${DateFormat.yMMMd().format(goal.lastUpdatedTaskDate ?? DateTime.now())}"
                  : "${goal.tasks.where((t) => !t.isDone).length} tasks remaining",
              style: theme.textTheme.bodySmall?.copyWith(
                color: (isCompleted
                        ? completedOnSurfaceColor
                        : theme.textTheme.bodySmall?.color)
                    ?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}