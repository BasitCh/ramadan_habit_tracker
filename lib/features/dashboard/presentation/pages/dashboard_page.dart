import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/extensions/date_extensions.dart';
import 'package:ramadan_habit_tracker/features/dashboard/presentation/widgets/daily_summary_card.dart';
import 'package:ramadan_habit_tracker/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:ramadan_habit_tracker/features/habits/presentation/bloc/habit_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final ramadanDay = now.ramadanDayNumber;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ramadan Tracker'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HabitBloc>().add(const LoadHabits());
          context.read<PrayerBloc>().add(LoadPrayerLog(now));
          context.read<QuranBloc>().add(LoadQuranProgress(now));
          context.read<FastingBloc>().add(const LoadFastingLogs());
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Ramadan day header
            Card(
              color: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Ramadan Mubarak',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ramadanDay != null
                          ? 'Day $ramadanDay of ${AppConstants.totalRamadanDays}'
                          : 'Ramadan starts ${AppConstants.ramadanStart.day}/${AppConstants.ramadanStart.month}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    if (ramadanDay != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: ramadanDay / AppConstants.totalRamadanDays,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Today's Progress",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Prayer summary
            BlocBuilder<PrayerBloc, PrayerState>(
              builder: (context, state) {
                if (state is PrayerLoaded) {
                  return DailySummaryCard(
                    title: 'Prayers',
                    value: '${state.prayerLog.completedCount}/${state.prayerLog.totalCount}',
                    subtitle: 'prayers completed',
                    icon: Icons.mosque,
                    color: AppColors.primary,
                  );
                }
                return const DailySummaryCard(
                  title: 'Prayers',
                  value: '-',
                  subtitle: 'loading...',
                  icon: Icons.mosque,
                );
              },
            ),
            const SizedBox(height: 8),

            // Quran & Habits row
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<QuranBloc, QuranState>(
                    builder: (context, state) {
                      if (state is QuranLoaded) {
                        return DailySummaryCard(
                          title: 'Quran',
                          value: '${state.progress.pagesRead}',
                          subtitle: 'pages today',
                          icon: Icons.menu_book,
                          color: AppColors.secondary,
                        );
                      }
                      return const DailySummaryCard(
                        title: 'Quran',
                        value: '-',
                        subtitle: 'loading...',
                        icon: Icons.menu_book,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BlocBuilder<HabitBloc, HabitState>(
                    builder: (context, state) {
                      if (state is HabitLoaded) {
                        final completed = state.todayLogs
                            .where((l) => l.completed)
                            .length;
                        return DailySummaryCard(
                          title: 'Habits',
                          value: '$completed/${state.habits.length}',
                          subtitle: 'completed',
                          icon: Icons.checklist,
                          color: AppColors.success,
                        );
                      }
                      return const DailySummaryCard(
                        title: 'Habits',
                        value: '-',
                        subtitle: 'loading...',
                        icon: Icons.checklist,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Fasting summary
            BlocBuilder<FastingBloc, FastingState>(
              builder: (context, state) {
                if (state is FastingLoaded) {
                  final todayFasted = state.fastingDays.any(
                    (d) => d.date.isToday && d.completed,
                  );
                  return DailySummaryCard(
                    title: 'Fasting',
                    value: todayFasted ? 'Fasting' : 'Not Logged',
                    subtitle: '${state.completedCount} days fasted total',
                    icon: Icons.restaurant,
                    color: todayFasted ? AppColors.success : AppColors.warning,
                  );
                }
                return const DailySummaryCard(
                  title: 'Fasting',
                  value: '-',
                  subtitle: 'loading...',
                  icon: Icons.restaurant,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
