import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:todo/widgets/default_elevated_button.dart';
import 'package:todo/widgets/default_text_form_field.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime date = DateTime.now();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat('dd / MM / yyyy');
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.5,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                'Add Task',
                style: textTheme.titleLarge,
              ),
              const SizedBox(
                height: 32,
              ),
              DefaultTextFormField(
                hintText: 'Enter Task Title',
                controller: titleController,
                onChanged: (value) {
                  titleController.text = value;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Task title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              DefaultTextFormField(
                hintText: 'Enter Task Description',
                controller: descriptionController,
                onChanged: (value) {
                  descriptionController.text = value;
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Task Description is required';
                  }
                  return null;
                },
                maxLines: 2,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                'Selected Date',
                style: textTheme.titleMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () async {
                  DateTime? dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(
                      const Duration(
                        days: 200,
                      ),
                    ),
                    lastDate: DateTime.now().add(
                      const Duration(
                        days: 200,
                      ),
                    ),
                  );
                  if (dateTime != null) {
                    setState(() {
                      date = dateTime;
                    });
                  }
                },
                child: Text(
                  dateFormat.format(
                    date,
                  ),
                  style: textTheme.titleMedium,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              DefaultElevatedButton(
                text: 'Add Task',
                onPressed: addTask,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask() async {
    if (formKey.currentState!.validate()) {
      final userId = Provider.of<UserProvider>(
        context,
        listen: false,
      ).currentUser!.id;
      FirebaseFunctions.addTaskToFirestore(
        TaskModel(
          title: titleController.text,
          description: descriptionController.text,
          dateTime: date,
        ),
        userId,
      ).then(
        (_) {
          titleController.clear();
          descriptionController.clear();
          date = DateTime.now();
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          Provider.of<TasksProvider>(
            // ignore: use_build_context_synchronously
            context,
            listen: false,
          ).getTasks(userId);
          Fluttertoast.showToast(
            msg: "Task added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: AppTheme.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
      ).catchError(
        (error) {
          Fluttertoast.showToast(
            msg: 'Something went wrong',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
      );
    }
  }
}
