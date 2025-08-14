import 'package:auraflow/models/sticky_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class StickyNoteCard extends StatelessWidget {
  const StickyNoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  final StickyNote note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteColor = Color(int.parse(note.colorHex, radix: 16));

    final markdownStyle = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.black.withOpacity(0.8),
      ),
      h1: theme.textTheme.headlineSmall?.copyWith(color: Colors.black),
      h2: theme.textTheme.titleLarge?.copyWith(color: Colors.black),
      h3: theme.textTheme.titleMedium?.copyWith(color: Colors.black),
      listBullet: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.black.withOpacity(0.8),
      ),
      blockquoteDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: noteColor.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: noteColor, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MarkdownBody(
                  data: note.content,
                  styleSheet: markdownStyle,
                  // Enable all syntax options
                  selectable: true,
                  softLineBreak: true,
                ),
              ),
              const SizedBox(height: 8),
              // Footer row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat.yMMMd().format(note.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: Colors.black.withOpacity(0.6),
                    // FEATURE 1: Call the confirmation dialog instead of deleting directly
                    onPressed: () => _showDeleteConfirmation(context),
                    tooltip: "Delete Note",
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Note?"),
          content: const Text("Are you sure you want to permanently delete this sticky note?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                onDelete(); // Call the original onDelete callback
              },
            ),
          ],
        );
      },
    );
  }
}