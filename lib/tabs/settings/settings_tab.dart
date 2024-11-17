import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/login_screen.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).width;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: AppTheme.primaryColor,
              width: double.infinity,
              height: screenHeight * 0.4,
            ),
            PositionedDirectional(
              top: screenHeight * 0.05,
              start: screenHeight * 0.04,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.white,
                      ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Language',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButton(
                      menuWidth: double.infinity,
                      value: 'en',
                      items: const [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(
                            'English',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text(
                            'Arabic',
                          ),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Logout',
                      style: textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () {
                        FirebaseFunctions.logout();
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                        Provider.of<TasksProvider>(context, listen: false)
                            .tasks
                            .clear();
                        Provider.of<UserProvider>(context, listen: false)
                            .updateUser(null);
                      },
                      icon: const Icon(
                        Icons.logout,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
