import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette - Shocking Pink / Deep Purple
  static const Color primary = Color(0xFFFF1493); // Shocking Pink
  static const Color primaryDark = Color(0xFFD81B60);
  static const Color primaryLight = Color(0xFFFFF0F9); // Soft Pink

  // Secondary palette - Deep Purple
  static const Color secondary = Color(0xFF8A2BE2); // Vibrant Purple
  static const Color accent = Color(0xFF7000FF); // Deep Purple

  // Surface colors
  static const Color surface = Color(0xFFF8F6FF);
  static const Color surfaceLight = Color(0xFFFDFCFE);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceGlass = Color(0xFFFFFBFE);
  static const Color background = Color(0xFFF8F6FF);

  // Clay card shadow colors
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowDark = Color(0xFFD1C4E9);

  // Dark theme colors
  static const Color backgroundDark = Color(0xFF120B1A);
  static const Color surfaceDark = Color(0xFF2D2433);

  // Semantic colors
  static const Color success = Color(0xFF34A853);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFFA7D8FF);

  // Text colors
  static const Color textPrimary = Color(0xFF2D0A31); // Deep text
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;
  static const Color textHint = Color(0xFFB0B0B0);

  // Gradient colors for hero cards
  static const Color gradientStart = Color(0xFF7000FF); // Deep Purple
  static const Color gradientMid = Color(0xFFAA00CC);
  static const Color gradientEnd = Color(0xFFFF1493); // Shocking Pink
}
