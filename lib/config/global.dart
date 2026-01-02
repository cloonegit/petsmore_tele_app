import 'package:flutter/material.dart';

/// Centralized application colors.
/// All color references should use these constants.
class AppColors {
  // Primary Colors (Blue Theme)
  static const Color primary = Color(0xFF1976D2);        // Blue 700
  static const Color primaryLight = Color(0xFF42A5F5);   // Blue 400
  static const Color primaryDark = Color(0xFF1565C0);    // Blue 800
  
  // Light Backgrounds
  static const Color primaryBackground = Color(0xFFBBDEFB); // Blue 100
  static const Color primaryBackgroundLight = Color(0xFFE3F2FD); // Blue 50
  static const Color scaffoldBackground = Color(0xFFFAFAFA); // Grey 50
  
  // Accent Colors
  static const Color accent = Color(0xFF4CAF50);         // Green 500
  static const Color accentDark = Color(0xFF388E3C);     // Green 700
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);        // Green
  static const Color error = Color(0xFFE53935);          // Red
  static const Color warning = Color(0xFFFFA726);        // Orange
  static const Color info = Color(0xFF29B6F6);           // Light Blue
  
  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);
  
  // Transparent
  static const Color transparent = Colors.transparent;
}

/// Centralized text styles.
class AppTextStyles {
  static const String fontFamily = 'Poppins';
  
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  
  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  
  // Button
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );
  
  // Caption
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );
  
  // Dialog
  static const TextStyle dialogTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  static const TextStyle dialogBody = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    color: AppColors.black,
  );
  
  static const TextStyle dialogAction = TextStyle(
    fontSize: 17,
    color: Colors.blue,
  );
}

/// Centralized dimensions and spacing.
class AppDimensions {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  // Border Radius
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 24.0;
  static const double borderRadiusRound = 30.0;
  
  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // Button Heights
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 44.0;
  static const double buttonHeightL = 52.0;
}
