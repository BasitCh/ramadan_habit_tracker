import 'package:flutter/material.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitTile({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? AppColors.success : Colors.transparent,
              border: Border.all(
                color: isCompleted ? AppColors.success : AppColors.textSecondary,
                width: 2,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        subtitle: habit.description != null
            ? Text(
                habit.description!,
                style: const TextStyle(color: AppColors.textSecondary),
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
