import 'package:flutter/material.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';

class PrayerCard extends StatelessWidget {
  final String prayerName;
  final bool isCompleted;
  final VoidCallback onToggle;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.isCompleted,
    required this.onToggle,
  });

  IconData get _icon {
    switch (prayerName) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.wb_sunny_outlined;
      case 'Maghrib':
        return Icons.nights_stay_outlined;
      case 'Isha':
        return Icons.nights_stay;
      case 'Tahajjud':
        return Icons.dark_mode;
      case 'Taraweeh':
        return Icons.mosque;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCompleted ? AppColors.primary.withValues(alpha: 0.1) : null,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Icon(
                _icon,
                color: isCompleted ? AppColors.primary : AppColors.textSecondary,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  prayerName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppColors.success : Colors.transparent,
                  border: Border.all(
                    color: isCompleted ? AppColors.success : AppColors.textSecondary,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
