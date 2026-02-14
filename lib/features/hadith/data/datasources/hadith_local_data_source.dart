import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/hadith/data/models/hadith_cache_model.dart';

abstract class HadithLocalDataSource {
  Future<HadithCacheModel?> getCachedHadith();
  Future<void> cacheHadith(HadithCacheModel model);
  Future<HadithCacheModel> getFallbackHadith();
}

class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  final Box<HadithCacheModel> hadithBox;

  HadithLocalDataSourceImpl({required this.hadithBox});

  @override
  Future<HadithCacheModel?> getCachedHadith() async {
    try {
      if (hadithBox.isEmpty) return null;
      return hadithBox.values.first;
    } catch (e) {
      throw CacheException('Failed to read cached hadith: $e');
    }
  }

  @override
  Future<void> cacheHadith(HadithCacheModel model) async {
    try {
      await hadithBox.clear();
      await hadithBox.put('daily', model);
    } catch (e) {
      throw CacheException('Failed to cache hadith: $e');
    }
  }

  @override
  Future<HadithCacheModel> getFallbackHadith() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/hadiths.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

      if (jsonList.isEmpty) {
        throw const CacheException('No fallback hadiths found');
      }

      //Rotate based on day of year
      final dayOfYear = DateTime.now()
          .difference(DateTime(DateTime.now().year))
          .inDays;
      final index = dayOfYear % jsonList.length;
      final item = jsonList[index] as Map<String, dynamic>;

      return HadithCacheModel(
        text: item['text'] as String,
        book: item['book'] as String,
        reference: item['reference'] as String,
        narrator: item['narrator'] as String?,
        fetchedAt: DateTime.now(),
      );
    } catch (e) {
      throw CacheException('Failed to load fallback hadith: $e');
    }
  }
}
