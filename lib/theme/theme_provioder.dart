import 'package:bolig/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool dark = false;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themedata) {
    _themeData = themedata;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      dark = true;
    } else {
      themeData = lightMode;
      dark = false;
    }
  }
}
