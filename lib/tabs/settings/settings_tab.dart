import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/login_screen.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).width;
    TextTheme textTheme = Theme.of(context).textTheme;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
                  appLocalizations.settings,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizations.language,
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                      style: TextStyle(
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                      dropdownColor: settingsProvider.isDark
                          ? AppTheme.eerieBlack
                          : AppTheme.white,
                      value: settingsProvider.language,
                      decoration: InputDecoration(
                        fillColor: settingsProvider.isDark
                            ? AppTheme.eerieBlack
                            : AppTheme.white,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          alignment: Alignment.center,
                          value: 'en',
                          child: Text(
                            'English',
                          ),
                        ),
                        DropdownMenuItem(
                          alignment: Alignment.center,
                          value: 'ar',
                          child: Text(
                            'Arabic',
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        settingsProvider.changeLanguage(value!);
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      appLocalizations.theme,
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                      style: TextStyle(
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                      dropdownColor: settingsProvider.isDark
                          ? AppTheme.eerieBlack
                          : AppTheme.white,
                      value: settingsProvider.theme,
                      decoration: InputDecoration(
                        fillColor: settingsProvider.isDark
                            ? AppTheme.eerieBlack
                            : AppTheme.white,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          alignment: Alignment.center,
                          value: ThemeMode.light,
                          child: Text(
                            appLocalizations.light,
                          ),
                        ),
                        DropdownMenuItem(
                          alignment: Alignment.center,
                          value: ThemeMode.dark,
                          child: Text(
                            appLocalizations.dark,
                          ),
                        ),
                      ],
                      onChanged: (themeMode) {
                        settingsProvider.changeMode(themeMode!);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
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
                        Icons.login_outlined,
                      ),
                    ),
                    Text(
                      appLocalizations.logout,
                      style: textTheme.titleMedium,
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
