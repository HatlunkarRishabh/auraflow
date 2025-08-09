import 'package:auraflow/models/sticky_note.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StickyNoteNotifier extends ChangeNotifier {
  final Box<StickyNote> _stickyBox = Hive.box<StickyNote>('stickynotes');

  ValueListenable<Box<StickyNote>> get stickyNotesListenable => _stickyBox.listenable();

  Future<void> addStickyNote({required String content, String? colorHex}) async {
    final newNote = StickyNote(content: content, colorHex: colorHex ?? "FFFFF59D");
    await _stickyBox.add(newNote);
  }

  Future<void> updateStickyNote(StickyNote note) async {
    await note.save();
  }

  Future<void> deleteStickyNote(StickyNote note) async {
    await note.delete();
  }
}