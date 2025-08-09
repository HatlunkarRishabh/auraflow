// lib/models/sticky_note.dart
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'sticky_note.g.dart';

@HiveType(typeId: 3) 
class StickyNote extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  String colorHex;

  @HiveField(3)
  final DateTime createdAt;

  StickyNote({
    required this.content,
    this.colorHex = "FFFFF59D",
    DateTime? createdAt,
    String? id,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.id = id ?? const Uuid().v4();
}