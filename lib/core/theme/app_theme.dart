import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/dark_theme_colors.dart';
import 'package:organicplants/core/theme/light_theme_colors.dart';

class AppTheme {
  // ——— Enhanced brand colors ———
  //static final Color primaryColor = Color(0xFF2E7D32); // Deeper green
  static final Color primaryColor = Color(0xFF4CAF50);
  static final Color onPrimary = Color(0xffffffff); // Lighter green

  // ignore: deprecated_member_use
  static final Color primaryContainer = primaryColor.withOpacity(0.1);
  static final Color onPrimaryContianer = Color(0xFFDCDCDC);

  static const Color secondaryColor = Color(0xFFFF6F00);
  static const Color accentColor = Color(0xFF66BB6A);

  // ——— Accents ———
  static final Color offerColor = Color(0xFFE53935);
  static final Color error = Color(0xffE53935);
  static final Color starColor = Color(0xFFFFB300);
  static final Color successColor = Color(0xFF43A047);
  static final Color warningColor = Color(0xFFFF9800);

  // ---------------------------------------------------------------------------
  // ENHANCED LIGHT THEME
  // ---------------------------------------------------------------------------
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    brightness: Brightness.light,

    // Enhanced Scaffold
    scaffoldBackgroundColor: LightThemeColors.mediumGray,

    // Enhanced ColorScheme
    colorScheme: ColorScheme.light(
      primary: LightThemeColors.primaryGreen,
      onPrimary: LightThemeColors.pureWhite,
      // ignore: deprecated_member_use
      primaryContainer: LightThemeColors.primaryGreen.withOpacity(0.1),
      onPrimaryContainer: LightThemeColors.pureWhite,

      // ignore: deprecated_member_use
      onPrimaryFixed: LightThemeColors.primaryGreen,

      // ignore: deprecated_member_use
      secondary: LightThemeColors.secondaryOrange,
      onSecondary: LightThemeColors.deepBlack,
      // ignore: deprecated_member_use
      secondaryContainer: LightThemeColors.secondaryOrange.withOpacity(0.1),
      onSecondaryContainer: LightThemeColors.richBlack,

      surface: LightThemeColors.softWhite,
      onSurface: LightThemeColors.deepBlack,

      inverseSurface: LightThemeColors.lightGray,
      onInverseSurface: LightThemeColors.deepBlack,

      surfaceContainerHighest: LightThemeColors.mediumGray,
      surfaceContainerHigh: LightThemeColors.lightGray,
      surfaceContainer: LightThemeColors.mediumGray,

      onSurfaceVariant: LightThemeColors.softGrey,
      tertiary: LightThemeColors.mediumGray,
      error: LightThemeColors.errorRed,
      onError: Colors.white,
      outline: LightThemeColors.primaryBorder,
      outlineVariant: LightThemeColors.secondaryBorder,
      shadow: LightThemeColors.shadowLight,
    ),

    // Enhanced AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: LightThemeColors.mediumGray,

      foregroundColor: LightThemeColors.deepBlack,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      iconTheme: IconThemeData(color: LightThemeColors.deepBlack, size: 24),
    ),

    // Enhanced Card Theme
    cardTheme: CardThemeData(
      color: LightThemeColors.softWhite,
      elevation: 1,
      //shadowColor: LightThemeColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
    ),

    // Enhanced Text Theme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.primaryGreen,
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.mutedText,
        fontFamily: 'Poppins',
      ),
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      headlineLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.primaryGreen,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      titleMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.darkGray,
        fontFamily: 'Poppins',
      ),
      //used in search field
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      //onPrimary content for primary content
      labelLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: LightThemeColors.pureWhite,
        fontFamily: 'Poppins',
        overflow: TextOverflow.ellipsis,
        letterSpacing: 0.5,
      ),
      labelMedium: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
      //used for very small labels like term and policy
      labelSmall: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: LightThemeColors.deepBlack,
        fontFamily: 'Poppins',
      ),
    ),

    // Enhanced Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightThemeColors.primaryGreen,
        foregroundColor: LightThemeColors.pureWhite,
        //elevation: 2,
        //shadowColor: primaryColor.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: TextStyle(
          fontSize: 16.sp,
          color: LightThemeColors.primaryGreen,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),

    // Enhanced Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: LightThemeColors.primaryGreen,
        side: BorderSide(color: LightThemeColors.primaryGreen, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: TextStyle(
          fontSize: 16.sp,
          color: LightThemeColors.primaryGreen,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    // Enhanced Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightThemeColors.pureWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: LightThemeColors.primaryBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: LightThemeColors.primaryBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: LightThemeColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: LightThemeColors.errorRed),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(
        color: LightThemeColors.mutedText,
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
    ),
    // Enhanced ExpansionTile Theme
    expansionTileTheme: ExpansionTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide.none,
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide.none,
      ),
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      iconColor: LightThemeColors.primaryGreen,
      collapsedIconColor: LightThemeColors.primaryGreen,
      textColor: LightThemeColors.deepBlack,
      collapsedTextColor: LightThemeColors.deepBlack,
    ),
    // ignore: deprecated_member_use
    dividerColor: LightThemeColors.softGrey.withOpacity(0.5),
  );

  // ---------------------------------------------------------------------------
  // ENHANCED DARK THEME
  // ---------------------------------------------------------------------------
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    brightness: Brightness.dark,

    // Enhanced Scaffold
    scaffoldBackgroundColor: DarkThemeColors.richBlack,

    // Enhanced ColorScheme
    colorScheme: ColorScheme.dark(
      primary: DarkThemeColors.primaryGreen,
      onPrimary: DarkThemeColors.pureWhite,
      // ignore: deprecated_member_use
      primaryContainer: DarkThemeColors.primaryGreen.withOpacity(0.1),
      onPrimaryContainer: DarkThemeColors.pureWhite,
      primaryFixed: DarkThemeColors.pureWhite,
      secondary: DarkThemeColors.secondaryOrange,
      // ignore: deprecated_member_use
      secondaryContainer: DarkThemeColors.secondaryOrange.withOpacity(0.1),

      surface: DarkThemeColors.mediumCharcoal,
      onSurface: DarkThemeColors.lightGray,

      inverseSurface: DarkThemeColors.mediumCharcoal,
      onInverseSurface: DarkThemeColors.lightGray,

      surfaceContainerHighest: DarkThemeColors.richBlack,
      surfaceContainerHigh: DarkThemeColors.softCharcoal,
      surfaceContainer: DarkThemeColors.lightCharcoal,

      onSurfaceVariant: DarkThemeColors.mutedGray,

      onSecondary: DarkThemeColors.pureWhite,
      tertiary: DarkThemeColors.softCharcoal,
      error: DarkThemeColors.errorRed,
      onError: DarkThemeColors.pureWhite,
      outline: DarkThemeColors.darkBorder,
      outlineVariant: DarkThemeColors.lightBorder,
      shadow: DarkThemeColors.shadowLight,
    ),

    // Enhanced AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: DarkThemeColors.richBlack,
      foregroundColor: DarkThemeColors.lightGray,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      iconTheme: IconThemeData(
        color: DarkThemeColors.lightGray,
        size: AppSizes.iconMd,
      ),
    ),

    // Enhanced Card Theme
    cardTheme: CardThemeData(
      color: DarkThemeColors.mediumCharcoal,
      elevation: 1,
      //shadowColor: DarkThemeColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
    ),

    // Enhanced Text Theme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.primaryGreen,
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      headlineLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.primaryGreen,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.pureWhite,
        fontFamily: 'Poppins',
      ),
      titleMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      //used in search field
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.pureWhite,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      //onPrimary content for primary content
      labelLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: DarkThemeColors.pureWhite,
        fontFamily: 'Poppins',
        overflow: TextOverflow.ellipsis,
        letterSpacing: 0.5,
      ),
      labelMedium: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
      //used for very small labels like term and policy
      labelSmall: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: DarkThemeColors.lightGray,
        fontFamily: 'Poppins',
      ),
    ),

    // Enhanced Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkThemeColors.primaryGreen,
        foregroundColor: DarkThemeColors.pureWhite,
        // elevation: 2,
        // shadowColor: DarkThemeColors.primaryGreen.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: TextStyle(
          fontSize: 16.sp,
          color: DarkThemeColors.pureWhite,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),

    // Enhanced Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DarkThemeColors.primaryGreen,
        side: BorderSide(color: DarkThemeColors.primaryGreen, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: TextStyle(
          fontSize: 16.sp,
          //color: DarkThemeColors.pureWhite,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    // Enhanced Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarkThemeColors.softCharcoal,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: DarkThemeColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: DarkThemeColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: DarkThemeColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: DarkThemeColors.errorRed),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(
        color: DarkThemeColors.mutedGray,
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
    ),
    // Enhanced ExpansionTile Theme
    expansionTileTheme: ExpansionTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide.none,
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        side: BorderSide.none,
      ),
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      iconColor: DarkThemeColors.primaryGreen,
      collapsedIconColor: DarkThemeColors.primaryGreen,
      textColor: DarkThemeColors.lightGray,
      collapsedTextColor: DarkThemeColors.lightGray,
    ),
    // ignore: deprecated_member_use
    dividerColor: DarkThemeColors.mutedGray.withOpacity(0.5),
  );
}
