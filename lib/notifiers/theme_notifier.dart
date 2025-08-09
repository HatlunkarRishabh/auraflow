// lib/notifiers/theme_notifier.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the application's theme state, including dark mode and accent color.
///
/// Persists user preferences using SharedPreferences.
class ThemeNotifier extends ChangeNotifier {
  // Keys for storing preferences. Using constants prevents typos.
  static const String _darkModeKey = "isDarkMode";
  static const String _accentColorKey = "accentColor";

  bool _isDarkMode = false;
  Color _accentColor = Colors.blue;

  bool get isDarkMode => _isDarkMode;
  Color get accentColor => _accentColor;

  ThemeNotifier() {
    // Load saved preferences when the notifier is created.
    loadPreferences();
  }

  /// Toggles the current theme between light and dark mode.
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
    notifyListeners(); // Notify listeners to rebuild the UI.
  }

  /// Sets the primary accent color for the app's theme.
  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    final colorValue = prefs.getInt(_accentColorKey);
    _accentColor = colorValue != null ? Color(colorValue) : Colors.blue; 
    notifyListeners();
  }
}