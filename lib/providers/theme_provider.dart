import 'package:flutter/material.dart';
import '../services/persistence_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = PersistenceService.isDarkMode;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    PersistenceService.saveTheme(_isDarkMode);
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    PersistenceService.saveTheme(value);
    notifyListeners();
  }
}
