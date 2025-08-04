import 'package:flutter/material.dart';
import 'package:organicplants/core/theme/dark_theme_colors.dart';
import 'package:organicplants/core/theme/light_theme_colors.dart';

class AppShadows {
  // ——— Light Theme Shadows ———
  static List<BoxShadow> get lightCardShadow => [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.07),
      spreadRadius: 1,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get lightElevatedShadow => [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.2),
      spreadRadius: 1,
      blurRadius: 6,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get lightFloatingShadow => [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.16),
      spreadRadius: 2,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get lightIntenseShadow => [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.24),
      spreadRadius: 2,
      blurRadius: 10,
      offset: const Offset(0, 6),
    ),
  ];

  // ——— Dark Theme Shadows ———
  static List<BoxShadow> get darkCardShadow => [
    BoxShadow(
      color: DarkThemeColors.shadowLight,
      spreadRadius: 2,
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get darkElevatedShadow => [
    BoxShadow(
      color: DarkThemeColors.shadowIntense.withValues(alpha: 0.2),
      spreadRadius: 1,
      blurRadius: 6,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get darkFloatingShadow => [
    BoxShadow(
      color: DarkThemeColors.shadowHeavy,
      spreadRadius: 2,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get darkIntenseShadow => [
    BoxShadow(
      color: DarkThemeColors.shadowIntense,
      spreadRadius: 2,
      blurRadius: 10,
      offset: const Offset(0, 6),
    ),
  ];

  // ——— Theme-Aware Shadow Methods ———

  /// Get appropriate shadow based on theme brightness
  static List<BoxShadow> getCardShadow(Brightness brightness) {
    return brightness == Brightness.dark ? darkCardShadow : lightCardShadow;
  }

  static List<BoxShadow> getElevatedShadow(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkElevatedShadow
        : lightElevatedShadow;
  }

  static List<BoxShadow> getFloatingShadow(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkFloatingShadow
        : lightFloatingShadow;
  }

  static List<BoxShadow> getIntenseShadow(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkIntenseShadow
        : lightIntenseShadow;
  }

  // ——— Context-Based Shadow Methods ———

  /// Get card shadow using BuildContext
  static List<BoxShadow> cardShadow(BuildContext context) {
    return getCardShadow(Theme.of(context).brightness);
  }

  /// Get elevated shadow using BuildContext
  static List<BoxShadow> elevatedShadow(BuildContext context) {
    return getElevatedShadow(Theme.of(context).brightness);
  }

  /// Get floating shadow using BuildContext
  static List<BoxShadow> floatingShadow(BuildContext context) {
    return getFloatingShadow(Theme.of(context).brightness);
  }

  /// Get intense shadow using BuildContext
  static List<BoxShadow> intenseShadow(BuildContext context) {
    return getIntenseShadow(Theme.of(context).brightness);
  }

  // ——— Custom Shadow Methods ———

  /// Create custom shadow with specified parameters
  static List<BoxShadow> customShadow({
    required Color color,
    double spreadRadius = 1,
    double blurRadius = 4,
    Offset offset = const Offset(0, 2),
  }) {
    return [
      BoxShadow(
        color: color,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }

  /// Create shadow with opacity
  static List<BoxShadow> shadowWithOpacity({
    required Color baseColor,
    double opacity = 0.1,
    double spreadRadius = 1,
    double blurRadius = 4,
    Offset offset = const Offset(0, 2),
  }) {
    return [
      BoxShadow(
        color: baseColor.withValues(alpha: opacity),
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }

  // ——— Specialized Shadows ———

  /// Shadow for bottom navigation bar
  static List<BoxShadow> bottomNavShadow(BuildContext context) {
    return [
      BoxShadow(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? DarkThemeColors.shadowLight
                : Colors.grey.withValues(alpha: 0.08),
        spreadRadius: 0,
        blurRadius: 8,
        offset: const Offset(0, -2),
      ),
    ];
  }

  /// Shadow for floating action buttons
  static List<BoxShadow> fabShadow(BuildContext context) {
    return [
      BoxShadow(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? DarkThemeColors.shadowHeavy
                : Colors.grey.withValues(alpha: 0.2),
        spreadRadius: 2,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// Shadow for modals and dialogs
  static List<BoxShadow> modalShadow(BuildContext context) {
    return [
      BoxShadow(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? DarkThemeColors.shadowIntense
                : Colors.grey.withValues(alpha: 0.3),
        spreadRadius: 4,
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }

  /// Shadow for search fields
  static List<BoxShadow> searchFieldShadow(BuildContext context) {
    return [
      BoxShadow(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? DarkThemeColors.shadowLight
                : Colors.grey.withValues(alpha: 0.06),
        spreadRadius: 0,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  /// Shadow for product cards
  static List<BoxShadow> productCardShadow(BuildContext context) {
    return [
      BoxShadow(
        color:
            Theme.of(context).brightness == Brightness.dark
                // ignore: deprecated_member_use
                ? DarkThemeColors.shadowIntense.withOpacity(0.18)
                // ignore: deprecated_member_use
                : LightThemeColors.shadowIntense.withOpacity(0.18),
        spreadRadius: 2,
        blurRadius: 4,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// Shadow for buttons
  static List<BoxShadow> buttonShadow(BuildContext context) {
    return [
      BoxShadow(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? DarkThemeColors.shadowLight
                : Colors.grey.withValues(alpha: 0.1),
        spreadRadius: 0,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }
}
