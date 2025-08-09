// lib/models/goal.dart
import 'package:hive/hive.dart';
import 'package:auraflow/models/task.dart';
import 'package:uuid/uuid.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String colorHex;

  @HiveField(3)
  HiveList<Task> tasks;

  @HiveField(4)
  final DateTime createdAt;

  Goal({
    required this.name,
    this.colorHex = "FF9E9E9E", 
    HiveList<Task>? tasks,
    DateTime? createdAt,
    String? id,
  })  : this.tasks = tasks ?? HiveList(Hive.box<Task>('tasks')),
        this.createdAt = createdAt ?? DateTime.now(),
        this.id = id ?? const Uuid().v4();

  double get progress {
    if (tasks.isEmpty) return 0.0;
    final completedTasks = tasks.where((task) => task.isDone).length;
    return completedTasks / tasks.length;
  }
}