import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/tasks/task_item.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  DateTime focusDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: AppTheme.primaryColor,
          height: MediaQuery.sizeOf(context).height * 0.3,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'To Do List',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.white,
                      ),
                ),
                EasyInfiniteDateTimeLine(
                  firstDate: DateTime.now().subtract(
                    const Duration(
                      days: 200,
                    ),
                  ),
                  focusDate: focusDate,
                  lastDate: DateTime.now().add(
                    const Duration(
                      days: 200,
                    ),
                  ),
                  showTimelineHeader: false,
                  dayProps: EasyDayProps(
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
                  ),
                  onDateChange: (selectedDate) {
                    focusDate = selectedDate;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemBuilder: (_, index) => TaskItem(
              title: 'title ${index + 1}',
              description: 'description ${index + 1}',
            ),
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
