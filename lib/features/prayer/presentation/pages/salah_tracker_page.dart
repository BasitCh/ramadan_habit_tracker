import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_event.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_state.dart';

class SalahTrackerPage extends StatefulWidget {
  const SalahTrackerPage({super.key});

  static const _prayerIcons = {
    'Fajr': Icons.wb_twilight,
    'Dhuhr': Icons.sunny,
    'Asr': Icons.wb_sunny_outlined,
    'Maghrib': Icons.wb_twilight,
    'Isha': Icons.dark_mode,
  };

  @override
  State<SalahTrackerPage> createState() => _SalahTrackerPageState();
}

class _SalahTrackerPageState extends State<SalahTrackerPage> {
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    context.read<PrayerBloc>().add(const LoadPrayerTimesRequested());
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

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
                  const BackButton(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.getHijriDateString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Salah Tracker',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      color: AppColors.secondary,
                    ),
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
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.error,
                          ),
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
    final nextPrayer = _resolveNextPrayer(state.prayerTimes);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PrayerBloc>().add(const LoadPrayerTimesRequested());
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Next Prayer Hero Card
          if (nextPrayer != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [AppColors.gradientEnd, AppColors.gradientStart],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -16,
                    top: -16,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.alarm,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'UPCOMING PRAYER',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.8),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "'${nextPrayer.name}",
                            style: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'in ${_formatCountdown(nextPrayer.time)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Scheduled for ${nextPrayer.timeLabel} • Local Time',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Prayer List
          ...state.prayerTimes.map((prayer) {
            final isNext = nextPrayer?.name == prayer.name;
            final isPast = _isPastPrayer(prayer.time) && !prayer.isCompleted;
            return _buildPrayerCard(
              context,
              prayer,
              isNext: isNext,
              isPast: isPast,
            );
          }),

          const SizedBox(height: 24),

          // Streak Card
          if (state.streak != null) _buildStreakCard(context, state),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(
    BuildContext context,
    PrayerTime prayer, {
    required bool isNext,
    required bool isPast,
  }) {
    final isCompleted = prayer.isCompleted;
    final isFuture = !isNext && !isPast && !isCompleted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isNext
              ? Colors.white
              : Colors.white.withValues(alpha: isFuture ? 0.4 : 1.0),
          borderRadius: BorderRadius.circular(20),
          border: isNext
              ? Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                )
              : null,
          boxShadow: isNext
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                  ),
                ],
        ),
        child: Opacity(
          opacity: isFuture ? 0.6 : 1.0,
          child: Row(
            children: [
              // Prayer Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isNext
                      ? null
                      : isCompleted
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  gradient: isNext
                      ? const LinearGradient(
                          colors: [
                            AppColors.gradientEnd,
                            AppColors.gradientStart,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  boxShadow: isNext
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  SalahTrackerPage._prayerIcons[prayer.name] ??
                      Icons.access_time,
                  color: isNext
                      ? Colors.white
                      : isCompleted
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  size: 22,
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
                        fontWeight: FontWeight.bold,
                        fontSize: isNext ? 18 : 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      isNext ? '${prayer.time} • Current' : prayer.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: isNext
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: isNext
                            ? FontWeight.bold
                            : FontWeight.normal,
                        letterSpacing: isNext ? 1 : 0,
                      ),
                    ),
                  ],
                ),
              ),

              // Completion Toggle
              GestureDetector(
                onTap: () {
                  context.read<PrayerBloc>().add(
                    TogglePrayerRequested(prayer.name),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: isCompleted
                        ? const LinearGradient(
                            colors: [
                              AppColors.gradientEnd,
                              AppColors.gradientStart,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    border: isCompleted
                        ? null
                        : Border.all(
                            color: isNext
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : Colors.grey.shade200,
                            width: 2,
                          ),
                    boxShadow: isCompleted
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 22)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, PrayerLoaded state) {
    final streak = state.streak!;
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Clay-fire icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gradientEnd, AppColors.gradientStart],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${streak.currentStreak} Day Streak',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Unstoppable progress!',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    streak.currentStreak.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    'DAYS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Weekly dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final completed =
                  i < streak.weeklyCompletion.length &&
                  streak.weeklyCompletion[i];
              final isToday = i == 6;
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? AppColors.primary : AppColors.secondary,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (completed ? AppColors.primary : AppColors.secondary)
                              .withValues(alpha: 0.2),
                      blurRadius: 8,
                    ),
                  ],
                  border: isToday
                      ? Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                          width: 4,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    days[i],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  _NextPrayer? _resolveNextPrayer(List<PrayerTime> times) {
    if (times.isEmpty) return null;

    final now = DateTime.now();
    final sorted = List<PrayerTime>.from(times)
      ..sort((a, b) => _toMinutes(a.time).compareTo(_toMinutes(b.time)));

    for (final prayer in sorted) {
      final prayerTime = _toDateTimeToday(prayer.time);
      if (prayerTime != null && !prayerTime.isBefore(now)) {
        return _NextPrayer(
          name: prayer.name,
          time: prayerTime,
          timeLabel: prayer.time,
        );
      }
    }

    final first = sorted.first;
    final firstTime = _toDateTimeToday(first.time);
    if (firstTime == null) return null;
    return _NextPrayer(
      name: first.name,
      time: firstTime.add(const Duration(days: 1)),
      timeLabel: first.time,
    );
  }

  bool _isPastPrayer(String time) {
    final target = _toDateTimeToday(time);
    if (target == null) return false;
    return target.isBefore(DateTime.now());
  }

  DateTime? _toDateTimeToday(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  int _toMinutes(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour * 60 + minute;
  }

  String _formatCountdown(DateTime target) {
    final now = DateTime.now();
    var diff = target.difference(now);
    if (diff.isNegative) diff = Duration.zero;
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    if (hours == 0) return '${minutes}m';
    return '${hours}h ${minutes}m';
  }
}

class _NextPrayer {
  final String name;
  final DateTime time;
  final String timeLabel;

  const _NextPrayer({
    required this.name,
    required this.time,
    required this.timeLabel,
  });
}
