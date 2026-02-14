import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/dua/data/models/dua_model.dart';

abstract class DuaLocalDataSource {
  Future<void> seedFromJson(String assetPath);
  Future<DuaModel> getDailyDua();
  Future<void> toggleBookmark(String duaId);
  Future<void> markAsRecited(String duaId);
  Future<List<DuaModel>> getBookmarkedDuas();
}

class DuaLocalDataSourceImpl implements DuaLocalDataSource {
  final Box<DuaModel> duasBox;
  final SharedPreferences sharedPreferences;

  DuaLocalDataSourceImpl({
    required this.duasBox,
    required this.sharedPreferences,
  });

  @override
  Future<void> seedFromJson(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

      for (final item in jsonList) {
        final model = DuaModel.fromJson(item as Map<String, dynamic>);
        await duasBox.put(model.id, model);
      }
    } catch (e) {
      throw CacheException('Failed to seed duas: $e');
    }
  }

  @override
  Future<DuaModel> getDailyDua() async {
    try {
      if (duasBox.isEmpty) {
        throw const CacheException('No duas available');
      }

      final now = DateTime.now();
      final dateKey = _dateKey(now);

      final cachedDate = sharedPreferences.getString(AppConstants.dailyDuaDateKey);
      final cachedId = sharedPreferences.getString(AppConstants.dailyDuaIdKey);

      if (cachedDate == dateKey && cachedId != null) {
        final cached = duasBox.get(cachedId);
        if (cached != null) {
          return cached;
        }
      }

      // Rotate based on day of year
      final dayOfYear = now.difference(DateTime(now.year)).inDays;
      final index = dayOfYear % duasBox.length;
      final selected = duasBox.getAt(index) ?? duasBox.values.first;

      await sharedPreferences.setString(AppConstants.dailyDuaDateKey, dateKey);
      await sharedPreferences.setString(AppConstants.dailyDuaIdKey, selected.id);

      return selected;
    } catch (e) {
      throw CacheException('Failed to get daily dua: $e');
    }
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<void> toggleBookmark(String duaId) async {
    try {
      final dua = duasBox.get(duaId);
      if (dua == null) return;

      final updated = DuaModel(
        id: dua.id,
        arabic: dua.arabic,
        transliteration: dua.transliteration,
        translation: dua.translation,
        reference: dua.reference,
        isBookmarked: !dua.isBookmarked,
        isRecited: dua.isRecited,
      );
      await duasBox.put(duaId, updated);
    } catch (e) {
      throw CacheException('Failed to toggle bookmark: $e');
    }
  }

  @override
  Future<void> markAsRecited(String duaId) async {
    try {
      final dua = duasBox.get(duaId);
      if (dua == null) return;

      final updated = DuaModel(
        id: dua.id,
        arabic: dua.arabic,
        transliteration: dua.transliteration,
        translation: dua.translation,
        reference: dua.reference,
        isBookmarked: dua.isBookmarked,
        isRecited: true,
      );
      await duasBox.put(duaId, updated);
    } catch (e) {
      throw CacheException('Failed to mark as recited: $e');
    }
  }

  @override
  Future<List<DuaModel>> getBookmarkedDuas() async {
    try {
      return duasBox.values.where((d) => d.isBookmarked).toList();
    } catch (e) {
      throw CacheException('Failed to get bookmarked duas: $e');
    }
  }
}
