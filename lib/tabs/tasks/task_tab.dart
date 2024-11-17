import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/task_item.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  bool shouldGetTasks = true;
  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    double screenHeight = MediaQuery.sizeOf(context).height;
    TextTheme textTheme = Theme.of(context).textTheme;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    if (shouldGetTasks) {
      tasksProvider.getTasks(userId);
      shouldGetTasks = false;
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: AppTheme.primaryColor,
              width: double.infinity,
              height: screenHeight * 0.2,
            ),
            PositionedDirectional(
              top: screenHeight * 0.05,
              start: screenHeight * 0.04,
              child: Text(
                AppLocalizations.of(context)!.todoList,
                style: textTheme.titleLarge?.copyWith(
                  color: AppTheme.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.15),
              child: EasyInfiniteDateTimeLine(
                firstDate: DateTime.now().subtract(
                  const Duration(
                    days: 200,
                  ),
                ),
                focusDate: tasksProvider.dateTime,
                lastDate: DateTime.now().add(
                  const Duration(
                    days: 200,
                  ),
                ),
                showTimelineHeader: false,
                dayProps: EasyDayProps(
                  height: 90,
                  width: 60,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.eerieBlack
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    dayNumStyle: textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                    dayStrStyle: const TextStyle(
                      color: AppTheme.primaryColor,
                    ),
                    monthStrStyle: const TextStyle(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.eerieBlack
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    dayNumStyle: textTheme.titleMedium,
                    monthStrStyle: const TextStyle(
                      color: AppTheme.black,
                    ),
                  ),
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.eerieBlack
                          : AppTheme.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    dayNumStyle: textTheme.titleMedium,
                    monthStrStyle: const TextStyle(
                      color: AppTheme.black,
                    ),
                  ),
                  dayStructure: DayStructure.dayNumDayStr,
                ),
                onDateChange: (selectedDate) {
                  tasksProvider.changeDateTime(selectedDate);
                  tasksProvider.getTasks(userId);
                },
              ),
            ),
          ],
        ),
        tasksProvider.tasks.isEmpty
            ? Expanded(
                child: Center(
                  child: Text(
                    'You have no tasks',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppTheme.grey,
                    ),
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) => TaskItem(
                    taskModel: TaskModel(
                      title: tasksProvider.tasks[index].title,
                      description: tasksProvider.tasks[index].description,
                      dateTime: tasksProvider.tasks[index].dateTime,
                      id: tasksProvider.tasks[index].id,
                      isDone: tasksProvider.tasks[index].isDone,
                    ),
                  ),
                  itemCount: tasksProvider.tasks.length,
                ),
              ),
      ],
    );
  }
}
