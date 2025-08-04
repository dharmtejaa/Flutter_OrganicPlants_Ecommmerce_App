import 'package:flutter/material.dart';

class LightThemeColors {
  // ——— Clean White Shades (Perfect for Light Mode) ———
  static const Color pureWhite = Color(0xFFFFFFFF); // Pure white background
  static const Color softWhite = Color(0xFFFbFbFb); // Soft white surface
  static const Color lightGray = Color(0xFFfefefe); // Light gray background
  static const Color mediumGray = Color(0xFFF1F0F0); // Medium gray surface
  static const Color warmGray = Color(0xFFEEEEEE); // Warm gray container
  static const Color subtleGray = Color(0xFFE8E8E8); // Subtle gray variant
  static const Color coolGray = Color(0xFFE0E0E0); // Cool gray border

  // ——— Text Colors with Enhanced Contrast ———
  static const Color deepBlack = Color(0xFF1A1A1A); // Primary headings
  static const Color richBlack = Color(0xFF2D2D2D); // Secondary text
  static const Color darkGray = Color(0xFF313130); // Body text
  static const Color softGrey = Color(0xFF888888); // Caption text
  static const Color mutedText = Color(0xFF9E9E9E); // Disabled text
  static const Color lightText = Color(0xFFBDBDBD); // Placeholder text

  // ——— Border and Divider Colors ———
  static const Color primaryBorder = Color(0xFFE0E0E0); // Primary borders
  static const Color secondaryBorder = Color(0xFFF0F0F0); // Secondary borders
  static const Color subtleBorder = Color(0xFFF5F5F5); // Subtle borders
  static const Color dividerColor = Color(0xFFEEEEEE); // Dividers

  // ——— Accent Colors for Light Theme ———
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
  static Color shadowLight = Colors.grey.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.grey.withValues(alpha: 0.08);
  static Color shadowHeavy = Colors.grey.withValues(alpha: 0.12);
  // ignore: deprecated_member_use
  static Color shadowIntense = Colors.grey.withOpacity(0.1);

  // ——— Overlay Colors ———
  static Color overlayLight = Colors.black.withValues(alpha: 0.05);
  static Color overlayMedium = Colors.black.withValues(alpha: 0.1);
  static Color overlayHeavy = Colors.black.withValues(alpha: 0.2);
  static Color overlayIntense = Colors.black.withValues(alpha: 0.4);

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
    colors: [pureWhite, softWhite],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [pureWhite, lightGray],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ——— Color Schemes for Different Components ———

  // Background Colors
  static const List<Color> backgroundColors = [pureWhite, softWhite, lightGray];

  // Surface Colors
  static const List<Color> surfaceColors = [
    pureWhite,
    softWhite,
    lightGray,
    mediumGray,
  ];

  // Text Colors
  static const List<Color> textColors = [
    deepBlack,
    richBlack,
    darkGray,
    softGrey,
    mutedText,
    lightText,
  ];

  // Border Colors
  static const List<Color> borderColors = [
    primaryBorder,
    secondaryBorder,
    subtleBorder,
  ];

  // ——— Utility Methods ———

  /// Get a color with opacity for light theme
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Get a surface color based on elevation level
  static Color getSurfaceColor(int elevation) {
    switch (elevation) {
      case 0:
        return pureWhite;
      case 1:
        return softWhite;
      case 2:
        return lightGray;
      case 3:
        return mediumGray;
      case 4:
        return warmGray;
      case 5:
        return subtleGray;
      default:
        return coolGray;
    }
  }

  /// Get text color based on importance level
  static Color getTextColor(int importance) {
    switch (importance) {
      case 1: // Primary text
        return deepBlack;
      case 2: // Secondary text
        return richBlack;
      case 3: // Body text
        return darkGray;
      case 4: // Caption text
        return softGrey;
      case 5: // Disabled text
        return mutedText;
      default:
        return lightText;
    }
  }

  /// Get border color based on emphasis level
  static Color getBorderColor(int emphasis) {
    switch (emphasis) {
      case 1: // Primary borders
        return primaryBorder;
      case 2: // Secondary borders
        return secondaryBorder;
      case 3: // Subtle borders
        return subtleBorder;
      default:
        return dividerColor;
    }
  }

  /// Get shadow color based on intensity
  static Color getShadowColor(int intensity) {
    switch (intensity) {
      case 1: // Light shadow
        return shadowLight;
      case 2: // Medium shadow
        return shadowMedium;
      case 3: // Heavy shadow
        return shadowHeavy;
      case 4: // Intense shadow
        return shadowIntense;
      default:
        return shadowLight;
    }
  }

  /// Get overlay color based on intensity
  static Color getOverlayColor(int intensity) {
    switch (intensity) {
      case 1: // Light overlay
        return overlayLight;
      case 2: // Medium overlay
        return overlayMedium;
      case 3: // Heavy overlay
        return overlayHeavy;
      case 4: // Intense overlay
        return overlayIntense;
      default:
        return overlayLight;
    }
  }
}
