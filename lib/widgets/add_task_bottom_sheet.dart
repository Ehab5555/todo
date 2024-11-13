import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return Container(
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
                if (value == null || value.isEmpty) {
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
                if (value == null || value.isEmpty) {
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
    );
  }

  void addTask() {
    if (formKey.currentState!.validate()) {
      setState(() {
        titleController.clear();
        descriptionController.clear();
        date = DateTime.now();
      });
    }
  }
}
