import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/edit_task.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class TaskItem extends StatefulWidget {
  final TaskModel taskModel;

  const TaskItem({
    super.key,
    required this.taskModel,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  Color get color =>
      widget.taskModel.isDone ? AppTheme.green : AppTheme.primaryColor;
  @override
  Widget build(BuildContext context) {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    TextTheme textTheme = Theme.of(context).textTheme;
    Provider.of<TasksProvider>(context).getTasks(userId);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Container(
      margin: const EdgeInsets.all(10),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (_) {
                FirebaseFunctions.deleteTaskFromFireStore(
                        widget.taskModel.id, userId)
                    .then(
                  (_) {
                    Provider.of<TasksProvider>(
                      // ignore: use_build_context_synchronously
                      context,
                      listen: false,
                    ).getTasks(userId);
                  },
                ).catchError(
                  (error) {
                    Fluttertoast.showToast(
                      msg: 'Something went wrong',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                );

                setState(() {});
              },
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Card(
          color: settingsProvider.isDark ? AppTheme.eerieBlack : AppTheme.white,
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(context, EditTask.routeName,
                  arguments: widget.taskModel);
            },
            contentPadding: const EdgeInsets.all(15),
            title: Text(
              widget.taskModel.title,
              style: textTheme.titleLarge?.copyWith(
                color: color,
              ),
            ),
            subtitle: Text(
              widget.taskModel.description,
              style: textTheme.titleSmall,
            ),
            leading: Container(
              height: double.infinity,
              width: 4,
              color: color,
            ),
            trailing: widget.taskModel.isDone
                ? InkWell(
                    onTap: () async {
                      setState(() {
                        FirebaseFunctions.updateTaskInFirestore(
                          taskModel: TaskModel(
                            title: widget.taskModel.title,
                            description: widget.taskModel.description,
                            dateTime: widget.taskModel.dateTime,
                            id: widget.taskModel.id,
                            isDone: false,
                          ),
                          userId,
                        );
                        widget.taskModel.isDone = false;
                      });
                      TasksProvider().getTasks(userId);
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
                    onPressed: () async {
                      FirebaseFunctions.updateTaskInFirestore(
                        taskModel: TaskModel(
                          title: widget.taskModel.title,
                          description: widget.taskModel.description,
                          dateTime: widget.taskModel.dateTime,
                          id: widget.taskModel.id,
                          isDone: true,
                        ),
                        userId,
                      );
                      setState(() {
                        widget.taskModel.isDone = true;
                      });
                      TasksProvider().getTasks(userId);
                    },
                    child: const Icon(
                      Icons.done,
                      size: 30,
                      color: AppTheme.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
