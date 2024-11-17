import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/widgets/default_elevated_button.dart';
import 'package:todo/widgets/default_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final userId = Provider.of<UserProvider>(context).currentUser!.id;
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
                  padding: const EdgeInsets.all(20.0),
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
                        appLocalizations.todoList,
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
                      color: Provider.of<SettingsProvider>(context).isDark
                          ? AppTheme.eerieBlack
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          appLocalizations.edit_task,
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        DefaultTextFormField(
                          hintText: appLocalizations.enter_task_title,
                          controller: TextEditingController(
                            text: task.title,
                          ),
                          onChanged: (value) {
                            task.title = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Task Title is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        DefaultTextFormField(
                          hintText: appLocalizations.enter_task_desc,
                          controller: TextEditingController(
                            text: task.description,
                          ),
                          onChanged: (value) {
                            task.description = value;
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
                          appLocalizations.selected_date,
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
                          text: appLocalizations.edit_task,
                          onPressed: () {
                            FirebaseFunctions.updateTaskInFirestore(
                              taskModel: task,
                              userId,
                            ).then(
                              (_) {
                                Fluttertoast.showToast(
                                  msg: "Task Updated successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
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
