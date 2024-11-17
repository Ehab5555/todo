import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  String language = 'en';
  ThemeMode theme = ThemeMode.light;
  bool get isDark => theme == ThemeMode.dark ? true : false;

  void changeLanguage(String newLanguage) {
    language = newLanguage;
    notifyListeners();
  }

  void changeMode(ThemeMode themeMode) {
    theme = themeMode;
    notifyListeners();
  }
}
