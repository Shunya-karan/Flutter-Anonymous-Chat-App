import 'package:flutter/material.dart';
import 'package:frontend/core/storage/shared_pref_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> setTheme(ThemeMode mode)async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await SharedPrefService.saveThemeMode(mode.name);
    notifyListeners();
  }
  Future<void>LoadTheme()async{
    final SavedTheme =await SharedPrefService.getThemeMode();
    switch(SavedTheme){
      case "dark":
        _themeMode = ThemeMode.dark;
        break;
      case "light":
        _themeMode = ThemeMode.light;
        break;
      default:
        _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}