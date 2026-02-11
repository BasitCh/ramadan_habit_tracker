import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/entities/dhikr.dart';

part 'dhikr_model.g.dart';

@HiveType(typeId: 5)
class DhikrModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int targetCount;

  @HiveField(3)
  final int currentCount;

  DhikrModel({
    required this.id,
    required this.name,
    required this.targetCount,
    required this.currentCount,
  });

  factory DhikrModel.fromEntity(Dhikr dhikr) {
    return DhikrModel(
      id: dhikr.id,
      name: dhikr.name,
      targetCount: dhikr.targetCount,
      currentCount: dhikr.currentCount,
    );
  }

  Dhikr toEntity() {
    return Dhikr(
      id: id,
      name: name,
      targetCount: targetCount,
      currentCount: currentCount,
    );
  }
}
