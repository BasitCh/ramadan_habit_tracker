import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette - Lavender/Purple theme
  static const Color primary = Color(0xFFCCB3DB); // Lavender
  static const Color primaryDark = Color(0xFF9B7BA8); // Darker purple
  static const Color primaryLight = Color(0xFFE8DCEF); // Soft lavender

  // Secondary palette - Warm accent
  static const Color secondary = Color(0xFFFFB74D); // Warm orange/gold
  static const Color accent = Color(0xFF8B5CF6); // Purple accent

  // Surface colors - Soft backgrounds
  static const Color surface = Color(0xFFF8F6F9); // Soft background
  static const Color surfaceLight = Color(0xFFF7F6F7); // Light surface
  static const Color surfaceCard = Color(0xFFFFFFFF); // Card background
  static const Color surfaceGlass = Color(0xFFFFFBFE); // Glassmorphism
  static const Color background = Color(0xFFF7F6F7); // Main background

  // Clay card shadow colors
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowDark = Color(0xFFD1C4E9);

  // Dark theme colors
  static const Color backgroundDark = Color(0xFF1A151D);
  static const Color surfaceDark = Color(0xFF2D2433);

  // Semantic colors
  static const Color success = Color(0xFF98FB98); // Mint green
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFFA7D8FF); // Soft blue

  // Text colors
  static const Color textPrimary = Color(0xFF2D2433); // Deep purple-charcoal
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;
  static const Color textHint = Color(0xFFB0B0B0);

  // Gradient colors for hero cards
  static const Color gradientStart = Color(0xFFCCB3DB);
  static const Color gradientMid = Color(0xFFCCB3DB);
  static const Color gradientEnd = Color(0xFFA7D8FF);
}
