import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/entities/hadith.dart';

part 'hadith_cache_model.g.dart';

@HiveType(typeId: 17)
class HadithCacheModel extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final String book;

  @HiveField(2)
  final String reference;

  @HiveField(3)
  final String? narrator;

  @HiveField(4)
  final DateTime fetchedAt;

  HadithCacheModel({
    required this.text,
    required this.book,
    required this.reference,
    required this.narrator,
    required this.fetchedAt,
  });

  Hadith toEntity() => Hadith(
        text: text,
        book: book,
        reference: reference,
        narrator: narrator,
      );

  factory HadithCacheModel.fromEntity(Hadith hadith, DateTime fetchedAt) {
    return HadithCacheModel(
      text: hadith.text,
      book: hadith.book,
      reference: hadith.reference,
      narrator: hadith.narrator,
      fetchedAt: fetchedAt,
    );
  }
}
