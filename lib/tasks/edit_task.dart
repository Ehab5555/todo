import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/widgets/default_elevated_button.dart';
import 'package:todo/widgets/default_text_form_field.dart';

class EditTask extends StatefulWidget {
  static const String routeName = 'edit_task';
  const EditTask({super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat('dd / MM / yyyy');

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).width;
    TextTheme textTheme = Theme.of(context).textTheme;
    TaskModel task = ModalRoute.of(context)!.settings.arguments as TaskModel;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                color: AppTheme.primaryColor,
                width: double.infinity,
                height: screenHeight * 0.4,
              ),
              PositionedDirectional(
                top: screenHeight * 0.05,
                start: screenHeight * 0.04,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_sharp,
                          size: 30,
                          color: AppTheme.white,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        'ToDo List',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: screenHeight * 0.9,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Edit Task',
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        DefaultTextFormField(
                          hintText: 'Enter Task Title',
                          controller: TextEditingController(
                            text: task.title,
                          ),
                          onChanged: (value) {
                            task.title = value;
                          },
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        DefaultTextFormField(
                          hintText: 'Enter Task Description',
                          controller: TextEditingController(
                            text: task.description,
                          ),
                          onChanged: (value) {
                            task.description = value;
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
                                task.dateTime = dateTime;
                              });
                            }
                          },
                          child: Text(
                            dateFormat.format(
                              task.dateTime,
                            ),
                            style: textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        DefaultElevatedButton(
                          text: 'Add Task',
                          onPressed: () {
                            FirebaseFunctions.updateTaskInFirestore(
                                    taskModel: task)
                                .then(
                              (_) {
                                Fluttertoast.showToast(
                                  msg: "Task Updated successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: AppTheme.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
