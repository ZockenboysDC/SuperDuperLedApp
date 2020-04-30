import 'package:flutter/material.dart';

// https://www.youtube.com/watch?v=G7gV89hnooM
class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    _themeData = theme;

    notifyListeners();
  }
}