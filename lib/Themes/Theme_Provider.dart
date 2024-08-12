import 'package:flutter/material.dart';

import 'Dark_Theme.dart';
import 'Light_Theme.dart';

class ThemeProvider extends ChangeNotifier {
  // for the initial theme
  ThemeData _themeData = lightMode;

  //for the current theme
  ThemeData get themeData => _themeData;

  //check is our current theme is dark
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}