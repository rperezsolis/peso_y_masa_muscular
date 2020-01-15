import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:peso_y_masa_muscular/ui/home.dart';
import 'package:peso_y_masa_muscular/ui/theme_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences _prefs;
  String _colorPreference;
  MaterialColor _color;

  @override
  void initState() {
    _checkUserDefaultColor();
    super.initState();
  }

  void _checkUserDefaultColor() async {
    _prefs = await SharedPreferences.getInstance();
    _color = ThemeColor.checkUserDefaultColor(_prefs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: _color,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          home: Home(),
        );
      }
    );
  }
}
