import 'package:flutter/material.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime dateTime = DateTime.now();

  Future<void> getTasks(String userId) async {
    List<TaskModel> allTasks =
        await FirebaseFunctions.getAllTasksFromFireStore(userId);
    tasks = allTasks
        .where((task) =>
            task.dateTime.day == dateTime.day &&
            task.dateTime.month == dateTime.month &&
            task.dateTime.year == dateTime.year)
        .toList();
    notifyListeners();
  }

  changeDateTime(DateTime date) {
    dateTime = date;
    notifyListeners();
  }
}
