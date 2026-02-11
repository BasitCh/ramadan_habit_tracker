import 'package:flutter/material.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/entities/dhikr.dart';

class DhikrCounterWidget extends StatelessWidget {
  final Dhikr dhikr;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const DhikrCounterWidget({
    super.key,
    required this.dhikr,
    required this.onIncrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              dhikr.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onIncrement,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dhikr.isCompleted
                      ? AppColors.success
                      : AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: (dhikr.isCompleted
                              ? AppColors.success
                              : AppColors.primary)
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${dhikr.currentCount}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Target: ${dhikr.targetCount}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: dhikr.progress.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(
                  dhikr.isCompleted ? AppColors.success : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Reset'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
