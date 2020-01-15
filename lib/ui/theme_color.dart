import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeColor {
  static List<MaterialColor> _colors = [
    Colors.blue,
    Colors.pink,
    Colors.deepPurple,
    Colors.yellow,
    Colors.green,
    Colors.red,
  ];

  static MaterialColor checkUserDefaultColor(SharedPreferences prefs) {
    int index = prefs.getInt('color') ?? 0;
    return _colors[index];
  }

  static changeColor(SharedPreferences prefs, BuildContext context) async {
    int index = prefs.getInt('color') ?? 0;
    index = _getIndex(index);
    MaterialColor color = _colors[index];
    DynamicTheme.of(context).setThemeData(new ThemeData(
        primaryColor: color,
        primarySwatch: color
    ));
    await prefs.setInt('color', index);
  }

  static int _getIndex(int index) {
    index++;
    if(index==_colors.length) {
      index = 0;
    }
    return index;
  }
}