import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';

class TaskItem extends StatefulWidget {
  final String title;
  final String description;
  Color get color => isDone ? AppTheme.green : AppTheme.primaryColor;

  bool isDone;
  TaskItem({
    super.key,
    required this.title,
    required this.description,
    this.isDone = false,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
        title: Text(
          widget.title,
          style: textTheme.titleLarge?.copyWith(
            color: widget.color,
          ),
        ),
        subtitle: Text(
          widget.description,
          style: textTheme.titleSmall,
        ),
        leading: Container(
          height: double.infinity,
          width: 4,
          color: widget.color,
        ),
        trailing: widget.isDone
            ? InkWell(
                onTap: () {
                  setState(() {
                    widget.isDone = false;
                  });
                },
                child: Text(
                  'Is Done',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppTheme.green,
                  ),
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.isDone = true;
                  });
                },
                child: const Icon(
                  Icons.done,
                  size: 30,
                  color: AppTheme.white,
                ),
              ),
      ),
    );
  }
}
