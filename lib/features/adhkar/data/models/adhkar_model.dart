import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/adhkar/domain/entities/adhkar.dart';

part 'adhkar_model.g.dart';

@HiveType(typeId: 15)
class AdhkarModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String arabic;

  @HiveField(2)
  final String transliteration;

  @HiveField(3)
  final String translation;

  @HiveField(4)
  final int repetitions;

  @HiveField(5)
  final String reference;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final int currentCount;

  @HiveField(8)
  final String? lastResetDate;

  AdhkarModel({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.repetitions,
    required this.reference,
    required this.category,
    this.currentCount = 0,
    this.lastResetDate,
  });

  Adhkar toEntity() => Adhkar(
        id: id,
        arabic: arabic,
        transliteration: transliteration,
        translation: translation,
        repetitions: repetitions,
        reference: reference,
        category: category,
        currentCount: currentCount,
      );

  factory AdhkarModel.fromJson(Map<String, dynamic> json) => AdhkarModel(
        id: json['id'] as String,
        arabic: json['arabic'] as String,
        transliteration: json['transliteration'] as String,
        translation: json['translation'] as String,
        repetitions: json['repetitions'] as int,
        reference: json['reference'] as String,
        category: json['category'] as String,
      );
}
