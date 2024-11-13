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
          dateTime: (json['dateTime']),
          isDone: json['isDone'],
          id: json['id'],
        );
  Map<String, dynamic> toJSON() => {
        'id': id,
        'title': title,
        'description': description,
        'dateTime': dateTime.toIso8601String(),
        'isDone': isDone,
      };
}
