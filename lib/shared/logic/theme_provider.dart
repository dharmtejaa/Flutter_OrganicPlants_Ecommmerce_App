import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this

class ThemeProvider with ChangeNotifier {
  static const String _themeModeKey = 'themeMode'; // Key for SharedPreferences

  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  ThemeProvider() {
    _loadThemeMode(); // Load the saved theme preference when the provider is created
  }

  ThemeMode get themeMode => _themeMode;

  // This getter can be useful for displaying the current state in UI
  // For example, if you want to show "Dark Mode (System)" when ThemeMode.system
  // resolves to dark.
  bool get isDarkMode {
    // If ThemeMode is system, check the actual platform brightness
    if (_themeMode == ThemeMode.system) {
      // ignore: deprecated_member_use
      return WidgetsBinding.instance.window.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // New method to explicitly set the theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      // Only update if the mode has changed
      _themeMode = mode;
      _saveThemeMode(mode); // Save the new mode
      notifyListeners(); // Notify widgets listening to this provider
    }
  }

  // The previous toggleTheme method can still be used if you want a simple switch
  // that just goes between light and dark, ignoring system.
  // However, it's better to use setThemeMode directly with the desired ThemeMode.
  void toggleTheme(bool isOn) {
    setThemeMode(isOn ? ThemeMode.dark : ThemeMode.light);
  }

  // --- Persistence Logic ---
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedMode = prefs.getString(_themeModeKey);

    if (storedMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString().split('.').last == storedMode,
        orElse: () => ThemeMode.system,
      );
    }
    notifyListeners(); // Ensure UI updates after loading
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    // Store the enum name as a string (e.g., "light", "dark", "system")
    await prefs.setString(_themeModeKey, mode.name);
  }
}
