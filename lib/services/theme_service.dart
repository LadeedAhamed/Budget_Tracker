import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeServices extends ChangeNotifier{
  final SharedPreferences sharedPreferences;
  ThemeServices(this.sharedPreferences);

  static const darkThemeKey = "dark_theme";
  bool _darkTheme = true;

  set darkTheme(bool value){
    _darkTheme = value;
    sharedPreferences.setBool(darkThemeKey, value);
    notifyListeners();
  }

  bool get darkTheme =>  sharedPreferences.getBool(darkThemeKey) ?? _darkTheme;

}