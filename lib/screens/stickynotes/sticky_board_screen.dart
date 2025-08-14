// lib/screens/stickynotes/sticky_board_screen.dart
import 'package:auraflow/models/sticky_note.dart';
import 'package:auraflow/notifiers/sticky_note_notifier.dart';
import 'package:auraflow/screens/stickynotes/widgets/sticky_note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class StickyBoardScreen extends StatelessWidget {
  const StickyBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stickyNotifier = context.read<StickyNoteNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sticky Board"),
      ),
      body: ValueListenableBuilder<Box<StickyNote>>(
        valueListenable: stickyNotifier.stickyNotesListenable,
        builder: (context, box, _) {
          final notes = box.values.toList().cast<StickyNote>();

          if (notes.isEmpty) {
            return const Center(
              child: Text("No sticky notes yet.\nTap '+' to add one!"),
            );
          }

          return AnimationLimiter(
            child: MasonryGridView.count(
              padding: const EdgeInsets.all(12.0),
              crossAxisCount: 2, // 2 columns for a nice grid
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: StickyNoteCard(
                        note: note,
                        onTap: () => _showAddOrEditNoteDialog(context, note: note),
                        onDelete: () => stickyNotifier.deleteStickyNote(note),
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
          heroTag: 'sticky-board-fab',
        onPressed: () => _showAddOrEditNoteDialog(context),
        tooltip: 'Add Sticky Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  // A single dialog handles both creating and editing notes.
  void _showAddOrEditNoteDialog(BuildContext context, {StickyNote? note}) {
    final isEditing = note != null;
    final contentController = TextEditingController(text: isEditing ? note.content : '');
    Color pickerColor = isEditing ? Color(int.parse(note.colorHex, radix: 16)) : Colors.yellow;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Edit Note" : "New Note"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contentController,
                  autofocus: true,
                  maxLines: 5,
                  minLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Your note...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Note Color"),
                const SizedBox(height: 10),
                ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) => pickerColor = color,
                  pickerAreaHeightPercent: 0.5,
                  displayThumbColor: true,
                  labelTypes: const [],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              child: Text(isEditing ? "Save" : "Add"),
              onPressed: () {
                final content = contentController.text;
                if (content.isNotEmpty) {
                  final notifier = context.read<StickyNoteNotifier>();
                  final colorHex = pickerColor.value.toRadixString(16);

                  if (isEditing) {
                    note.content = content;
                    note.colorHex = colorHex;
                    notifier.updateStickyNote(note);
                  } else {
                    notifier.addStickyNote(content: content, colorHex: colorHex);
                  }
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