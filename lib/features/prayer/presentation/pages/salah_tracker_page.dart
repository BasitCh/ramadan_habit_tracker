import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/presentation/widgets/clay_card.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_event.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_state.dart';

class SalahTrackerPage extends StatelessWidget {
  const SalahTrackerPage({super.key});

  static const _prayerIcons = {
    'Fajr': Icons.wb_twilight,
    'Dhuhr': Icons.light_mode,
    'Asr': Icons.wb_sunny,
    'Maghrib': Icons.wb_twilight,
    'Isha': Icons.bedtime,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '12 Ramadan 1447',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textPrimary.withValues(alpha: 0.6),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Today's Salah",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                    child: const Icon(Icons.calendar_today_outlined, color: AppColors.textPrimary, size: 20),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<PrayerBloc, PrayerState>(
                builder: (context, state) {
                  if (state is PrayerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is PrayerError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                          const SizedBox(height: 16),
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<PrayerBloc>().add(
                                  const LoadPrayerTimesRequested(),
                                ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is PrayerLoaded) {
                    return _buildLoadedContent(context, state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, PrayerLoaded state) {
    final nextPrayer = state.prayerTimes.where((t) => t.isNext).firstOrNull;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        // Next Prayer Hero Card
        if (nextPrayer != null) ...[
          const SizedBox(height: 16),
          ClayCard(
            color: const Color(0xFFFFD6BA).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: AppColors.textPrimary.withValues(alpha: 0.7)),
                    const SizedBox(width: 8),
                    Text(
                      'NEXT PRAYER',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                        color: AppColors.textPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  nextPrayer.name,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Scheduled for ${nextPrayer.time}',
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Prayer List
        ...state.prayerTimes.map((prayer) => _buildPrayerCard(context, prayer)),

        const SizedBox(height: 24),

        // Streak Card
        if (state.streak != null) _buildStreakCard(context, state),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPrayerCard(BuildContext context, PrayerTime prayer) {
    final isNext = prayer.isNext;
    final isCompleted = prayer.isCompleted;
    final isPast = !isNext && !isCompleted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isNext ? Colors.white : Colors.white.withValues(alpha: isCompleted ? 1.0 : 0.6),
          borderRadius: BorderRadius.circular(16),
          border: isNext
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2)
              : null,
          boxShadow: isNext
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 12)]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4)],
        ),
        child: Row(
          children: [
            // Prayer Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isNext
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                _prayerIcons[prayer.name] ?? Icons.access_time,
                color: isNext ? Colors.white : AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),

            // Prayer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prayer.name,
                    style: TextStyle(
                      fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                      fontSize: isNext ? 18 : 16,
                      color: isPast
                          ? AppColors.textPrimary.withValues(alpha: 0.7)
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    isNext ? '${prayer.time} • Current' : prayer.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isNext ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isNext ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Completion Toggle
            GestureDetector(
              onTap: () {
                context.read<PrayerBloc>().add(TogglePrayerRequested(prayer.name));
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isCompleted ? AppColors.primary : Colors.transparent,
                  border: isCompleted
                      ? null
                      : Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                ),
                child: isCompleted
                    ? const Icon(Icons.done, color: Colors.white, size: 20)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, PrayerLoaded state) {
    final streak = state.streak!;
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return ClayCard(
      padding: const EdgeInsets.all(20),
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Column(
        children: [
          Row(
            children: [
              // Fire icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A71),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF8A71).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.local_fire_department, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${streak.currentStreak} Day Streak',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "You're staying consistent!",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${streak.currentStreak}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'DAYS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Weekly dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final completed = i < streak.weeklyCompletion.length && streak.weeklyCompletion[i];
              return Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Text(
                    days[i],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: completed ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
