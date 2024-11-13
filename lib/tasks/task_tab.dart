import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tasks/task_item.dart';
import 'package:todo/tasks/tasks_provider.dart';

class TaskTab extends StatelessWidget {
  const TaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    double screenHeight = MediaQuery.sizeOf(context).height;

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
                'ToDo List',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    dayNumStyle:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
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
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    dayNumStyle: Theme.of(context).textTheme.titleMedium,
                    dayStrStyle: const TextStyle(
                      color: AppTheme.black,
                    ),
                    monthStrStyle: const TextStyle(
                      color: AppTheme.black,
                    ),
                  ),
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppTheme.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    dayNumStyle: Theme.of(context).textTheme.titleMedium,
                    dayStrStyle: const TextStyle(
                      color: AppTheme.black,
                    ),
                    monthStrStyle: const TextStyle(
                      color: AppTheme.black,
                    ),
                  ),
                  dayStructure: DayStructure.dayNumDayStr,
                ),
                onDateChange: (selectedDate) {
                  tasksProvider.changeDateTime(selectedDate);
                  tasksProvider.getTasks();
                },
              ),
            ),
          ],
        ),
        tasksProvider.tasks.isEmpty
            ? const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
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
