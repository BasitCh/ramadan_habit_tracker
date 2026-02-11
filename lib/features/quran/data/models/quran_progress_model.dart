import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';

part 'quran_progress_model.g.dart';

@HiveType(typeId: 3)
class QuranProgressModel extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int currentJuz;

  @HiveField(2)
  final int pagesRead;

  QuranProgressModel({
    required this.date,
    required this.currentJuz,
    required this.pagesRead,
  });

  factory QuranProgressModel.fromEntity(QuranProgress progress) {
    return QuranProgressModel(
      date: progress.date,
      currentJuz: progress.currentJuz,
      pagesRead: progress.pagesRead,
    );
  }

  QuranProgress toEntity() {
    return QuranProgress(
      date: date,
      currentJuz: currentJuz,
      pagesRead: pagesRead,
    );
  }
}
