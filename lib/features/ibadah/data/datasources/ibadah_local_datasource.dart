import 'dart:math';
import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/ibadah/data/models/ibadah_checklist_model.dart';

abstract class IbadahLocalDataSource {
  Future<IbadahChecklistModel> getChecklist(String dateKey);
  Future<IbadahChecklistModel> toggleItem(String dateKey, String item);
  Future<int> getTotalCharityCount();
}

class IbadahLocalDataSourceImpl implements IbadahLocalDataSource {
  final Box<IbadahChecklistModel> checklistBox;

  IbadahLocalDataSourceImpl({required this.checklistBox});

  @override
  Future<IbadahChecklistModel> getChecklist(String dateKey) async {
    try {
      final existing = checklistBox.get(dateKey);
      if (existing != null) {
        return existing;
      }

      // Generate 5 random items based on date
      final date = DateTime.parse(dateKey); // dateKey is YYYY-MM-DD
      final seed = date.year * 1000 + date.month * 100 + date.day;
      final random = Random(seed);
      final allItems = List<String>.from(AppConstants.allIbadahItems);
      allItems.shuffle(random);
      final dailyItems = allItems.take(5).toList();

      final model = IbadahChecklistModel(
        dateKey: dateKey,
        items: dailyItems,
        values: List<bool>.filled(dailyItems.length, false),
      );

      await checklistBox.put(dateKey, model);
      return model;
    } catch (e) {
      throw CacheException('Failed to load ibadah checklist: $e');
    }
  }

  @override
  Future<IbadahChecklistModel> toggleItem(String dateKey, String item) async {
    try {
      final model = await getChecklist(dateKey);
      final index = model.items.indexOf(item);
      if (index == -1) return model;

      final updatedValues = List<bool>.from(model.values);
      updatedValues[index] = !updatedValues[index];

      final updated = IbadahChecklistModel(
        dateKey: dateKey,
        items: List<String>.from(model.items),
        values: updatedValues,
      );

      await checklistBox.put(dateKey, updated);
      return updated;
    } catch (e) {
      throw CacheException('Failed to toggle ibadah item: $e');
    }
  }

  @override
  Future<int> getTotalCharityCount() async {
    try {
      int count = 0;
      // Iterate through all stored checklists
      for (var model in checklistBox.values) {
        final index = model.items.indexOf('Charity (Sadaqah)');
        // Check if item exists and is checked
        if (index != -1 && model.values[index]) {
          count++;
        }
      }
      return count;
    } catch (e) {
      // Return 0 instead of throwing to avoid breaking UI for stats
      return 0;
    }
  }
}
