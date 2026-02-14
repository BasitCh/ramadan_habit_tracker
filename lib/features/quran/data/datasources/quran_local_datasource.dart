import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/quran_progress_model.dart';

abstract class QuranLocalDataSource {
  Future<QuranProgressModel> getProgress();
  Future<QuranProgressModel> updatePagesRead(int pages);
  Future<QuranProgressModel> resetProgress();
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  final Box<QuranProgressModel> progressBox;

  QuranLocalDataSourceImpl({required this.progressBox});

  static const _key = 'quran_progress';

  @override
  Future<QuranProgressModel> getProgress() async {
    try {
      final existing = progressBox.get(_key);
      if (existing != null) return existing;

      final initial = QuranProgressModel.initial();
      await progressBox.put(_key, initial);
      return initial;
    } catch (e) {
      throw CacheException('Failed to get Quran progress: $e');
    }
  }

  @override
  Future<QuranProgressModel> updatePagesRead(int pages) async {
    try {
      final current = progressBox.get(_key) ?? QuranProgressModel.initial();
      final now = DateTime.now();
      final lastRead = DateTime.fromMillisecondsSinceEpoch(
        current.lastReadTimestamp,
      );

      // Reset daily count if new day
      final isNewDay =
          now.day != lastRead.day ||
          now.month != lastRead.month ||
          now.year != lastRead.year;

      final updated = QuranProgressModel(
        currentPage: (current.currentPage + pages).clamp(0, 604),
        pagesReadToday: isNewDay ? pages : current.pagesReadToday + pages,
        lastReadTimestamp: now.millisecondsSinceEpoch,
      );

      await progressBox.put(_key, updated);
      return updated;
    } catch (e) {
      throw CacheException('Failed to update Quran progress: $e');
    }
  }

  @override
  Future<QuranProgressModel> resetProgress() async {
    try {
      final initial = QuranProgressModel.initial();
      await progressBox.put(_key, initial);
      return initial;
    } catch (e) {
      throw CacheException('Failed to reset Quran progress: $e');
    }
  }
}
