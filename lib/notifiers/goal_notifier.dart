import 'package:auraflow/models/goal.dart';
import 'package:auraflow/models/task.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GoalNotifier extends ChangeNotifier {
  final Box<Goal> _goalBox = Hive.box<Goal>('goals');


  ValueListenable<Box<Goal>> get goalsListenable => _goalBox.listenable();

  Future<void> addGoal({required String name, required String colorHex}) async {
    final newGoal = Goal(name: name, colorHex: colorHex);
    await _goalBox.add(newGoal);
  }

  Future<void> updateGoal(Goal goal) async {
    await goal.save();
  }

  Future<void> deleteGoal(Goal goal) async {
    await goal.delete();
  }
  

  Future<void> addTaskToGoal(Goal goal, Task task) async {
    goal.tasks.add(task);
    await goal.save(); 
  }
  
  Future<void> updateTask(Task task) async {
     await task.save();
  }

  Future<void> deleteTask(Task task) async {
     await task.delete();
  }
}