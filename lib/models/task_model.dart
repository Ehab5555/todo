import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String title;
  String description;
  DateTime dateTime;
  bool isDone;

  TaskModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.dateTime,
    this.isDone = false,
  });
  TaskModel.fromJSON(Map<String, dynamic> json)
      : this(
          title: json['title'],
          description: json['description'],
          dateTime: (json['dateTime'] as Timestamp).toDate(),
          isDone: json['isDone'],
          id: json['id'],
        );
  Map<String, dynamic> toJSON() => {
        'id': id,
        'title': title,
        'description': description,
        'dateTime': Timestamp.fromDate(dateTime),
        'isDone': isDone,
      };
}
