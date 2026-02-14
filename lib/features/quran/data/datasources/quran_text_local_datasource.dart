import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/surah_detail_cache_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/surah_list_cache_model.dart';

abstract class QuranTextLocalDataSource {
  Future<SurahListCacheModel?> getCachedSurahList();
  Future<void> cacheSurahList(SurahListCacheModel model);
  Future<SurahDetailCacheModel?> getCachedSurahDetail(int surahNumber);
  Future<void> cacheSurahDetail(SurahDetailCacheModel model);
}

class QuranTextLocalDataSourceImpl implements QuranTextLocalDataSource {
  final Box<SurahListCacheModel> surahListBox;
  final Box<SurahDetailCacheModel> surahDetailBox;

  QuranTextLocalDataSourceImpl({
    required this.surahListBox,
    required this.surahDetailBox,
  });

  @override
  Future<SurahListCacheModel?> getCachedSurahList() async {
    try {
      if (surahListBox.isEmpty) return null;
      return surahListBox.values.first;
    } catch (e) {
      throw CacheException('Failed to read cached surah list: $e');
    }
  }

  @override
  Future<void> cacheSurahList(SurahListCacheModel model) async {
    try {
      await surahListBox.clear();
      await surahListBox.put('list', model);
    } catch (e) {
      throw CacheException('Failed to cache surah list: $e');
    }
  }

  @override
  Future<SurahDetailCacheModel?> getCachedSurahDetail(int surahNumber) async {
    try {
      return surahDetailBox.get(surahNumber);
    } catch (e) {
      throw CacheException('Failed to read cached surah detail: $e');
    }
  }

  @override
  Future<void> cacheSurahDetail(SurahDetailCacheModel model) async {
    try {
      await surahDetailBox.put(model.number, model);
    } catch (e) {
      throw CacheException('Failed to cache surah detail: $e');
    }
  }
}
