import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/hijri_date.dart';
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
  final HijriDate? hijriDate;
  final String? locationLabel;

  const PrayerLoaded({
    required this.prayerTimes,
    required this.prayerLog,
    this.streak,
    this.nextPrayerCountdown,
    this.hijriDate,
    this.locationLabel,
  });

  PrayerLoaded copyWith({
    List<PrayerTime>? prayerTimes,
    PrayerLog? prayerLog,
    PrayerStreak? streak,
    String? nextPrayerCountdown,
    HijriDate? hijriDate,
    String? locationLabel,
  }) {
    return PrayerLoaded(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      prayerLog: prayerLog ?? this.prayerLog,
      streak: streak ?? this.streak,
      nextPrayerCountdown: nextPrayerCountdown ?? this.nextPrayerCountdown,
      hijriDate: hijriDate ?? this.hijriDate,
      locationLabel: locationLabel ?? this.locationLabel,
    );
  }

  @override
  List<Object?> get props => [
        prayerTimes,
        prayerLog,
        streak,
        nextPrayerCountdown,
        hijriDate,
        locationLabel,
      ];
}

class PrayerError extends PrayerState {
  final String message;

  const PrayerError(this.message);

  @override
  List<Object> get props => [message];
}
