import 'package:flutter/material.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';

/// iOS-style status bar showing time and indicators
class IosStatusBar extends StatelessWidget {
  final Color? textColor;
  final Color? backgroundColor;

  const IosStatusBar({
    super.key,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.now();
    final timeString = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

    return Container(
      height: 48,
      width: double.infinity,
      color: backgroundColor ?? Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            timeString,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor ?? AppColors.textPrimary,
            ),
          ),

          // Status indicators
          Row(
            children: [
              Icon(
                Icons.signal_cellular_alt,
                size: 16,
                color: textColor ?? AppColors.textPrimary,
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.wifi,
                size: 16,
                color: textColor ?? AppColors.textPrimary,
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.battery_full,
                size: 20,
                color: textColor ?? AppColors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// iOS-style home indicator at the bottom
class IosHomeIndicator extends StatelessWidget {
  final Color? color;

  const IosHomeIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 128,
        height: 4,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: color ?? AppColors.textSecondary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
