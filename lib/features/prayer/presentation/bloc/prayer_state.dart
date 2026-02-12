import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_streak.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';

sealed class PrayerState extends Equatable {
  const PrayerState();

  @override
  List<Object?> get props => [];
}

class PrayerInitial extends PrayerState {
  const PrayerInitial();
}

class PrayerLoading extends PrayerState {
  const PrayerLoading();
}

class PrayerLoaded extends PrayerState {
  final List<PrayerTime> prayerTimes;
  final PrayerLog prayerLog;
  final PrayerStreak? streak;
  final String? nextPrayerCountdown;

  const PrayerLoaded({
    required this.prayerTimes,
    required this.prayerLog,
    this.streak,
    this.nextPrayerCountdown,
  });

  PrayerLoaded copyWith({
    List<PrayerTime>? prayerTimes,
    PrayerLog? prayerLog,
    PrayerStreak? streak,
    String? nextPrayerCountdown,
  }) {
    return PrayerLoaded(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      prayerLog: prayerLog ?? this.prayerLog,
      streak: streak ?? this.streak,
      nextPrayerCountdown: nextPrayerCountdown ?? this.nextPrayerCountdown,
    );
  }

  @override
  List<Object?> get props => [prayerTimes, prayerLog, streak, nextPrayerCountdown];
}

class PrayerError extends PrayerState {
  final String message;

  const PrayerError(this.message);

  @override
  List<Object> get props => [message];
}
