import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/hijri_date.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';

class PrayerTimesResult extends Equatable {
  final List<PrayerTime> prayerTimes;
  final HijriDate? hijriDate;

  const PrayerTimesResult({
    required this.prayerTimes,
    required this.hijriDate,
  });

  @override
  List<Object?> get props => [prayerTimes, hijriDate];
}
