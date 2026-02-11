import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/extensions/date_extensions.dart';
import 'package:ramadan_habit_tracker/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:ramadan_habit_tracker/features/fasting/presentation/widgets/fasting_day_card.dart';

class FastingPage extends StatelessWidget {
  const FastingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fasting Tracker')),
      body: BlocBuilder<FastingBloc, FastingState>(
        builder: (context, state) {
          if (state is FastingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FastingError) {
            return Center(child: Text(state.message));
          }
          if (state is FastingLoaded) {
            final completedCount = state.completedCount;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '$completedCount / ${AppConstants.totalRamadanDays}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Days Fasted',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: completedCount / AppConstants.totalRamadanDays,
                            minHeight: 8,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ramadan Days',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: AppConstants.totalRamadanDays,
                  itemBuilder: (context, index) {
                    final dayNumber = index + 1;
                    final date = AppConstants.ramadanStart.add(
                      Duration(days: index),
                    );
                    final isCompleted = state.fastingDays.any(
                      (d) => d.date.isSameDay(date) && d.completed,
                    );

                    return FastingDayCard(
                      dayNumber: dayNumber,
                      date: date,
                      isCompleted: isCompleted,
                      onToggle: () {
                        context
                            .read<FastingBloc>()
                            .add(ToggleFastingRequested(date));
                      },
                    );
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
