import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.name,
    required super.englishName,
    required super.englishNameTranslation,
    required super.numberOfAyahs,
    required super.revelationType,
  });

  factory SurahModel.fromApiJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      englishName: json['englishName']?.toString() ?? '',
      englishNameTranslation: json['englishNameTranslation']?.toString() ?? '',
      numberOfAyahs: json['numberOfAyahs'] as int? ?? 0,
      revelationType: json['revelationType']?.toString() ?? '',
    );
  }
}
