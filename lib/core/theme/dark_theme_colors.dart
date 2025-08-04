import 'package:flutter/material.dart';

class DarkThemeColors {
  // ——— Rich Black Shades (Perfect for OLED screens) ———
  static const Color richBlack = Color(0xFF000000); // Deepest black
  static const Color charcoal = Color(0xFF121212); // Material Design dark
  static const Color darkCharcoal = Color(0xFF1A1A1A); // Card background
  static const Color mediumCharcoal = Color(0xFF1E1E1E); // Surface background
  static const Color lightCharcoal = Color(0xFF242424); // Elevated surface
  static const Color softCharcoal = Color(0xFF2A2A2A); // Surface variant
  static const Color warmCharcoal = Color(0xFF2E2E2E); // Container background

  // ——— Text Colors with Better Contrast ———
  static const Color pureWhite = Color(0xFFFFFFFF); // Primary text
  static const Color softWhite = Color(0xFFF5F5F5); // Secondary text
  static const Color lightGray = Color(0xFFE8E8E8); // Surface text
  static const Color softGray = Color(0xFFD0D0D0); // Container text
  static const Color mutedGray = Color(0xFFB8B8B8); // Variant text
  static const Color subtleGray = Color(0xFF9E9E9E); // Disabled text

  // ——— Border and Divider Colors ———
  static const Color darkBorder = Color(0xFF4A4A4A); // Primary borders
  static const Color mediumBorder = Color(0xFF3A3A3A); // Secondary borders
  static const Color lightBorder = Color(0xFF2A2A2A); // Subtle borders
  static const Color dividerColor = Color(0xFF2E2E2E); // Dividers

  // ——— Accent Colors for Dark Theme ———
  static const Color primaryGreen = Color(0xFF4CAF50); // Main brand color
  static const Color primaryGreenLight = Color(0xFF66BB6A); // Light variant
  static const Color primaryGreenDark = Color(0xFF2E7D32); // Dark variant

  static const Color secondaryOrange = Color(0xFFFF6F00); // Secondary brand
  static const Color secondaryOrangeLight = Color(0xFFFF8A50); // Light variant

  static const Color accentBlue = Color(0xFF2196F3); // Info color
  static const Color accentPurple = Color(0xFF9C27B0); // Special accent
  static const Color accentTeal = Color(0xFF009688); // Alternative accent

  // ——— Status Colors ———
  static const Color successGreen = Color(0xFF43A047); // Success state
  static const Color warningOrange = Color(0xFFFF9800); // Warning state
  static const Color errorRed = Color(0xFFE53935); // Error state
  static const Color infoBlue = Color(0xFF2196F3); // Info state

  // ——— Rating and Special Colors ———
  static const Color starGold = Color(0xFFFFB300); // Star ratings
  static const Color starGoldLight = Color(0xFFFFC107); // Light star
  static const Color offerRed = Color(0xFFE53935); // Offer/discount
  static const Color priceGreen = Color(0xFF2E7D32); // Price color

  // ——— Shadow Colors ———
  static Color shadowLight = Colors.black.withValues(alpha: 0.07);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.2);
  static Color shadowHeavy = Colors.black.withValues(alpha: 0.4);
  static Color shadowIntense = Colors.black.withValues(alpha: 0.1);

  // ——— Overlay Colors ———
  static Color overlayLight = Colors.black.withValues(alpha: 0.07);
  static Color overlayMedium = Colors.black.withValues(alpha: 0.3);
  static Color overlayHeavy = Colors.black.withValues(alpha: 0.5);
  static Color overlayIntense = Colors.black.withValues(alpha: 0.8);

  // ——— Gradient Definitions ———
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreenDark, primaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryOrange, secondaryOrangeLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [richBlack, charcoal],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [darkCharcoal, mediumCharcoal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ——— Color Schemes for Different Components ———

  // Background Colors
  static const List<Color> backgroundColors = [
    richBlack,
    charcoal,
    darkCharcoal,
  ];

  // Surface Colors
  static const List<Color> surfaceColors = [
    mediumCharcoal,
    lightCharcoal,
    softCharcoal,
    warmCharcoal,
  ];

  // Text Colors
  static const List<Color> textColors = [
    pureWhite,
    softWhite,
    lightGray,
    softGray,
    mutedGray,
    subtleGray,
  ];

  // Border Colors
  static const List<Color> borderColors = [
    darkBorder,
    mediumBorder,
    lightBorder,
  ];

  // ——— Utility Methods ———

  /// Get a color with opacity for dark theme
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Get a surface color based on elevation level
  static Color getSurfaceColor(int elevation) {
    switch (elevation) {
      case 0:
        return richBlack;
      case 1:
        return charcoal;
      case 2:
        return darkCharcoal;
      case 3:
        return mediumCharcoal;
      case 4:
        return lightCharcoal;
      case 5:
        return softCharcoal;
      default:
        return warmCharcoal;
    }
  }

  /// Get text color based on importance level
  static Color getTextColor(int importance) {
    switch (importance) {
      case 1: // Primary text
        return pureWhite;
      case 2: // Secondary text
        return softWhite;
      case 3: // Body text
        return lightGray;
      case 4: // Caption text
        return softGray;
      case 5: // Disabled text
        return mutedGray;
      default:
        return subtleGray;
    }
  }
}
