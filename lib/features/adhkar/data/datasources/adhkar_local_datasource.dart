import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/adhkar/data/models/adhkar_model.dart';

abstract class AdhkarLocalDataSource {
  Future<void> seedFromJson(String assetPath);
  Future<List<AdhkarModel>> getByCategory(String category);
  Future<AdhkarModel> incrementCount(String adhkarId);
  Future<void> resetDailyProgress();
}

class AdhkarLocalDataSourceImpl implements AdhkarLocalDataSource {
  final Box<AdhkarModel> adhkarBox;

  AdhkarLocalDataSourceImpl({required this.adhkarBox});

  @override
  Future<void> seedFromJson(String assetPath) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      for (final item in jsonList) {
        final model = AdhkarModel.fromJson(item as Map<String, dynamic>);
        await adhkarBox.put(model.id, model);
      }
    } catch (e) {
      throw CacheException('Failed to seed adhkar: $e');
    }
  }

  @override
  Future<List<AdhkarModel>> getByCategory(String category) async {
    try {
      _checkAndResetDaily();
      return adhkarBox.values.where((a) => a.category == category).toList();
    } catch (e) {
      throw CacheException('Failed to get adhkar: $e');
    }
  }

  @override
  Future<AdhkarModel> incrementCount(String adhkarId) async {
    try {
      final adhkar = adhkarBox.get(adhkarId);
      if (adhkar == null) throw const CacheException('Adhkar not found');

      final todayKey = _todayKey();
      final updated = AdhkarModel(
        id: adhkar.id,
        arabic: adhkar.arabic,
        transliteration: adhkar.transliteration,
        translation: adhkar.translation,
        repetitions: adhkar.repetitions,
        reference: adhkar.reference,
        category: adhkar.category,
        currentCount: (adhkar.currentCount + 1).clamp(0, adhkar.repetitions),
        lastResetDate: todayKey,
      );
      await adhkarBox.put(adhkarId, updated);
      return updated;
    } catch (e) {
      throw CacheException('Failed to increment adhkar: $e');
    }
  }

  @override
  Future<void> resetDailyProgress() async {
    try {
      final todayKey = _todayKey();
      for (final key in adhkarBox.keys) {
        final adhkar = adhkarBox.get(key);
        if (adhkar != null && adhkar.lastResetDate != todayKey) {
          final reset = AdhkarModel(
            id: adhkar.id,
            arabic: adhkar.arabic,
            transliteration: adhkar.transliteration,
            translation: adhkar.translation,
            repetitions: adhkar.repetitions,
            reference: adhkar.reference,
            category: adhkar.category,
            currentCount: 0,
            lastResetDate: todayKey,
          );
          await adhkarBox.put(key, reset);
        }
      }
    } catch (e) {
      throw CacheException('Failed to reset adhkar: $e');
    }
  }

  void _checkAndResetDaily() {
    final todayKey = _todayKey();
    for (final key in adhkarBox.keys) {
      final adhkar = adhkarBox.get(key);
      if (adhkar != null && adhkar.lastResetDate != null && adhkar.lastResetDate != todayKey && adhkar.currentCount > 0) {
        final reset = AdhkarModel(
          id: adhkar.id,
          arabic: adhkar.arabic,
          transliteration: adhkar.transliteration,
          translation: adhkar.translation,
          repetitions: adhkar.repetitions,
          reference: adhkar.reference,
          category: adhkar.category,
          currentCount: 0,
          lastResetDate: todayKey,
        );
        adhkarBox.put(key, reset);
      }
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
