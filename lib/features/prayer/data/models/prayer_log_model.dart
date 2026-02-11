import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';

part 'prayer_log_model.g.dart';

@HiveType(typeId: 2)
class PrayerLogModel extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final Map<String, bool> prayers;

  PrayerLogModel({
    required this.date,
    required this.prayers,
  });

  factory PrayerLogModel.fromEntity(PrayerLog log) {
    return PrayerLogModel(
      date: log.date,
      prayers: Map<String, bool>.from(log.prayers),
    );
  }

  PrayerLog toEntity() {
    return PrayerLog(
      date: date,
      prayers: Map<String, bool>.from(prayers),
    );
  }
}
