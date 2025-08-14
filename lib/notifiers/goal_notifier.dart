import 'package:auraflow/models/goal.dart';
import 'package:auraflow/models/task.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';


class GoalNotifier extends ChangeNotifier {
  final Box<Goal> _goalBox = Hive.box<Goal>('goals');

  Goal? _selectedGoal;
  Goal? get selectedGoal => _selectedGoal;

  void selectGoal(Goal? goal) {
    if (_selectedGoal != goal) {
      _selectedGoal = goal;
      notifyListeners();
    }
  }

  ValueListenable<Box<Goal>> get goalsListenable => _goalBox.listenable();

  Future<void> addGoal({required String name, required String colorHex}) async {
    final newGoal = Goal(name: name, colorHex: colorHex);
    await _goalBox.add(newGoal);
  }

  Future<void> deleteGoal(Goal goal) async {
    final tasksToDelete = goal.tasks.toList();
    for (final task in tasksToDelete) {
      final subTasksToDelete = task.subTasks.toList();
      for (final subTask in subTasksToDelete) {
        await subTask.delete();
      }
      await task.delete();
    }
    await goal.delete();
  }

  Future<void> addTaskToGoal(Goal goal, Task task) async {
    final taskBox = Hive.box<Task>('tasks');
    await taskBox.add(task);
    goal.tasks.add(task);
    await goal.save();
    notifyListeners(); 
  }

  Future<void> updateTask(Task task) async {
  await task.save();

  try {
    final parentGoal = _goalBox.values.firstWhere(
      (goal) => goal.tasks.contains(task),
    );

    final isCompleted = parentGoal.progress >= 1.0;

    if (isCompleted && parentGoal.lastUpdatedTaskDate == null) {
      parentGoal.lastUpdatedTaskDate = DateTime.now();
    }
    else if (!isCompleted && parentGoal.lastUpdatedTaskDate != null) {
      parentGoal.lastUpdatedTaskDate = null;
    }

    await parentGoal.save();
  } catch (e) {
    debugPrint("Could not find parent goal for task update: $e");
  }
}

Future<void> deleteTask(Task task) async {
    final parentGoal = _goalBox.values.firstWhere(
    (goal) => goal.tasks.contains(task),
  );
  
  final subTasksToDelete = task.subTasks.toList();
  for (final subTask in subTasksToDelete) {
    await subTask.delete();
  }
  
  await task.delete();
  
  await parentGoal.save();
  notifyListeners();
  }


  Future<void> addSubTaskToTask(Task parentTask, SubTask subTask) async {
    final subTaskBox = Hive.box<SubTask>('subtasks');
    await subTaskBox.add(subTask);
    parentTask.subTasks.add(subTask);
    await parentTask.save(); 
  }

  Future<void> deleteSubTask(SubTask subTask) async {
    final parentTask = Hive.box<Task>('tasks').values.firstWhere(
      (task) => task.subTasks.contains(subTask)
    );
    await subTask.delete();
    await parentTask.save(); 
  }
}