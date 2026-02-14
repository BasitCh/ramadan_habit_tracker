import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah.dart';

part 'surah_list_cache_model.g.dart';

@HiveType(typeId: 18)
class SurahListCacheModel extends HiveObject {
  @HiveField(0)
  final List<int> numbers;

  @HiveField(1)
  final List<String> names;

  @HiveField(2)
  final List<String> englishNames;

  @HiveField(3)
  final List<String> englishNameTranslations;

  @HiveField(4)
  final List<int> ayahCounts;

  @HiveField(5)
  final List<String> revelationTypes;

  @HiveField(6)
  final DateTime fetchedAt;

  SurahListCacheModel({
    required this.numbers,
    required this.names,
    required this.englishNames,
    required this.englishNameTranslations,
    required this.ayahCounts,
    required this.revelationTypes,
    required this.fetchedAt,
  });

  List<Surah> toEntities() {
    final list = <Surah>[];
    for (var i = 0; i < numbers.length; i++) {
      list.add(Surah(
        number: numbers[i],
        name: names[i],
        englishName: englishNames[i],
        englishNameTranslation: englishNameTranslations[i],
        numberOfAyahs: ayahCounts[i],
        revelationType: revelationTypes[i],
      ));
    }
    return list;
  }

  factory SurahListCacheModel.fromEntities(List<Surah> surahs, DateTime fetchedAt) {
    return SurahListCacheModel(
      numbers: surahs.map((s) => s.number).toList(),
      names: surahs.map((s) => s.name).toList(),
      englishNames: surahs.map((s) => s.englishName).toList(),
      englishNameTranslations: surahs.map((s) => s.englishNameTranslation).toList(),
      ayahCounts: surahs.map((s) => s.numberOfAyahs).toList(),
      revelationTypes: surahs.map((s) => s.revelationType).toList(),
      fetchedAt: fetchedAt,
    );
  }
}
