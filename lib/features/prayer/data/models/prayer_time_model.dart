import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';

part 'prayer_time_model.g.dart';

@HiveType(typeId: 11)
class PrayerTimeModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String time;

  PrayerTimeModel({required this.name, required this.time});

  factory PrayerTimeModel.fromEntity(PrayerTime entity) {
    return PrayerTimeModel(name: entity.name, time: entity.time);
  }

  PrayerTime toEntity({bool isCompleted = false, bool isNext = false}) {
    return PrayerTime(
      name: name,
      time: time,
      isCompleted: isCompleted,
      isNext: isNext,
    );
  }

  factory PrayerTimeModel.fromApiJson(String name, String time) {
    return PrayerTimeModel(name: name, time: time);
  }
}
