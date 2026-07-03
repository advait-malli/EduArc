import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeController extends ChangeNotifier {
  ThemeMode mode = ThemeMode.system;
  Color seedColor = Colors.blue;

  static const String _themeModeKey = 'theme_mode';
  static const String _seedColorKey = 'seed_color';

  AppThemeController() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final themeModeIndex =
        prefs.getInt(_themeModeKey) ?? 2; // Default to system (index 2)
    mode = ThemeMode.values[themeModeIndex];

    // Load seed color
    final seedColorValue =
        prefs.getInt(_seedColorKey) ?? 0xFF2196F3; // Default to blue
    seedColor = Color(seedColorValue);

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Save theme mode
    await prefs.setInt(_themeModeKey, mode.index);

    // Save seed color (convert Color to int)
    // ignore: deprecated_member_use
    await prefs.setInt(_seedColorKey, seedColor.value);

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode m) async {
    mode = m;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setSeedColor(Color color) async {
    seedColor = color;
    await _saveSettings();
    notifyListeners();
  }
}
