import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/ayah.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah_detail.dart';

part 'surah_detail_cache_model.g.dart';

@HiveType(typeId: 19)
class SurahDetailCacheModel extends HiveObject {
  @HiveField(0)
  final int number;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String englishName;

  @HiveField(3)
  final String englishNameTranslation;

  @HiveField(4)
  final int numberOfAyahs;

  @HiveField(5)
  final String revelationType;

  @HiveField(6)
  final List<int> ayahNumbers;

  @HiveField(7)
  final List<String> arabicAyahs;

  @HiveField(8)
  final List<String> translations;

  @HiveField(9)
  final DateTime fetchedAt;

  SurahDetailCacheModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.ayahNumbers,
    required this.arabicAyahs,
    required this.translations,
    required this.fetchedAt,
  });

  SurahDetail toEntity() {
    final surah = Surah(
      number: number,
      name: name,
      englishName: englishName,
      englishNameTranslation: englishNameTranslation,
      numberOfAyahs: numberOfAyahs,
      revelationType: revelationType,
    );

    final ayahs = <Ayah>[];
    for (var i = 0; i < ayahNumbers.length; i++) {
      ayahs.add(Ayah(
        numberInSurah: ayahNumbers[i],
        arabicText: arabicAyahs[i],
        translation: translations[i],
      ));
    }

    return SurahDetail(surah: surah, ayahs: ayahs);
  }

  factory SurahDetailCacheModel.fromEntity(SurahDetail detail, DateTime fetchedAt) {
    return SurahDetailCacheModel(
      number: detail.surah.number,
      name: detail.surah.name,
      englishName: detail.surah.englishName,
      englishNameTranslation: detail.surah.englishNameTranslation,
      numberOfAyahs: detail.surah.numberOfAyahs,
      revelationType: detail.surah.revelationType,
      ayahNumbers: detail.ayahs.map((a) => a.numberInSurah).toList(),
      arabicAyahs: detail.ayahs.map((a) => a.arabicText).toList(),
      translations: detail.ayahs.map((a) => a.translation).toList(),
      fetchedAt: fetchedAt,
    );
  }
}
