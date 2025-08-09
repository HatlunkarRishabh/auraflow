import 'package:hive/hive.dart';
import 'package:auraflow/models/task_priority.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 2) 
class SubTask extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isDone;

  SubTask({required this.name, this.isDone = false});
}

@HiveType(typeId: 1) 
class Task extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  TaskPriority priority;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  HiveList<SubTask> subTasks;

  @HiveField(6)
  final DateTime createdAt;

  Task({
    required this.name,
    this.isDone = false,
    this.priority = TaskPriority.medium,
    this.dueDate,
    HiveList<SubTask>? subTasks,
    DateTime? createdAt,
    String? id,
  })  : this.subTasks = subTasks ?? HiveList(Hive.box<SubTask>('subtasks')),
        this.createdAt = createdAt ?? DateTime.now(),
        this.id = id ?? const Uuid().v4();
}