import 'package:flutter/material.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/extensions/date_extensions.dart';

class FastingDayCard extends StatelessWidget {
  final int dayNumber;
  final DateTime date;
  final bool isCompleted;
  final VoidCallback onToggle;

  const FastingDayCard({
    super.key,
    required this.dayNumber,
    required this.date,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = date.isToday;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted
              ? AppColors.success
              : isToday
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: isToday
              ? Border.all(color: AppColors.primary, width: 2)
              : Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$dayNumber',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Icon(
              isCompleted ? Icons.check_circle : Icons.circle_outlined,
              size: 16,
              color: isCompleted ? Colors.white : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
