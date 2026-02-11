import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/extensions/date_extensions.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/quran_progress_model.dart';

abstract class QuranLocalDataSource {
  Future<QuranProgressModel> getQuranProgress(DateTime date);
  Future<QuranProgressModel> updateQuranProgress(QuranProgressModel progress);
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  final Box<QuranProgressModel> quranProgressBox;

  QuranLocalDataSourceImpl({required this.quranProgressBox});

  @override
  Future<QuranProgressModel> getQuranProgress(DateTime date) async {
    try {
      final key = date.dateKey;
      final existing = quranProgressBox.get(key);
      if (existing != null) return existing;

      final defaultProgress = QuranProgressModel(
        date: DateTime(date.year, date.month, date.day),
        currentJuz: 1,
        pagesRead: 0,
      );
      await quranProgressBox.put(key, defaultProgress);
      return defaultProgress;
    } catch (e) {
      throw const CacheException('Failed to get Quran progress');
    }
  }

  @override
  Future<QuranProgressModel> updateQuranProgress(QuranProgressModel progress) async {
    try {
      final key = progress.date.dateKey;
      await quranProgressBox.put(key, progress);
      return progress;
    } catch (e) {
      throw const CacheException('Failed to update Quran progress');
    }
  }
}
