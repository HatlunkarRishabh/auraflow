// lib/screens/widgets/quick_add_dialog.dart
import 'package:auraflow/notifiers/goal_notifier.dart';
import 'package:auraflow/notifiers/sticky_note_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows a universal "Quick Add" dialog.
///
/// The content of the dialog intelligently changes based on the currently
/// selected page index from the main navigation shell.
void showQuickAddDialog(BuildContext context, int selectedIndex) {
  // Determine what to add based on the current screen.
  // 0 = Goals, 1 = Stickies
  if (selectedIndex == 0) {
    _showAddGoalDialog(context);
  } else if (selectedIndex == 1) {
    _showAddStickyNoteDialog(context);
  }
  // For index 2 (Settings), we do nothing.
}

// A private helper to show the dialog for adding a new Goal.
void _showAddGoalDialog(BuildContext context) {
  final goalNameController = TextEditingController();
  // We can add a color picker here later if desired, for now, a default.
  const String defaultColorHex = "FF9E9E9E";

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Create New Goal"),
      content: TextField(
        controller: goalNameController,
        autofocus: true,
        decoration: const InputDecoration(labelText: "Goal Name"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          child: const Text("Create"),
          onPressed: () {
            if (goalNameController.text.isNotEmpty) {
              context.read<GoalNotifier>().addGoal(
                    name: goalNameController.text,
                    colorHex: defaultColorHex,
                  );
              Navigator.pop(context);
            }
          },
        ),
      ],
    ),
  );
}

// A private helper to show the dialog for adding a new Sticky Note.
void _showAddStickyNoteDialog(BuildContext context) {
  final contentController = TextEditingController();
  const String defaultColorHex = "FFFFF59D";

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("New Sticky Note"),
      content: TextField(
        controller: contentController,
        autofocus: true,
        maxLines: 4,
        decoration: const InputDecoration(
          labelText: "Your note...",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          child: const Text("Add"),
          onPressed: () {
            if (contentController.text.isNotEmpty) {
              context.read<StickyNoteNotifier>().addStickyNote(
                    content: contentController.text,
                    colorHex: defaultColorHex,
                  );
              Navigator.pop(context);
            }
          },
        ),
      ],
    ),
  );
}