import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';

part 'quran_progress_model.g.dart';

@HiveType(typeId: 13)
class QuranProgressModel extends HiveObject {
  @HiveField(0)
  final int currentPage;

  @HiveField(1)
  final int pagesReadToday;

  @HiveField(2)
  final int lastReadTimestamp;

  QuranProgressModel({
    required this.currentPage,
    required this.pagesReadToday,
    required this.lastReadTimestamp,
  });

  factory QuranProgressModel.initial() {
    return QuranProgressModel(
      currentPage: 0,
      pagesReadToday: 0,
      lastReadTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  QuranProgress toEntity() {
    return QuranProgress(
      currentPage: currentPage,
      pagesReadToday: pagesReadToday,
      lastReadDate: DateTime.fromMillisecondsSinceEpoch(lastReadTimestamp),
    );
  }

  factory QuranProgressModel.fromEntity(QuranProgress entity) {
    return QuranProgressModel(
      currentPage: entity.currentPage,
      pagesReadToday: entity.pagesReadToday,
      lastReadTimestamp: entity.lastReadDate.millisecondsSinceEpoch,
    );
  }
}
