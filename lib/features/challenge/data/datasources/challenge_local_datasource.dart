import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/challenge/data/models/challenge_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChallengeLocalDataSource {
  Future<List<ChallengeModel>> getChallenges();
  Future<void> completeChallenge(int day);
  Future<void> uncompleteChallenge(int day);
  Future<bool> isChallengeCompleted(int day);
}

class ChallengeLocalDataSourceImpl implements ChallengeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ChallengeLocalDataSourceImpl({required this.sharedPreferences});

  static const String _completedChallengesKey = 'completed_challenges';

  @override
  Future<List<ChallengeModel>> getChallenges() async {
    try {
      final completedDays =
          sharedPreferences.getStringList(_completedChallengesKey) ?? [];
      final completedSet = completedDays.map((e) => int.parse(e)).toSet();

      return AppConstants.ramadanChallenges.map((data) {
        final day = data['day'] as int;
        return ChallengeModel(
          day: day,
          title: data['title'] as String,
          description: data['description'] as String,
          isCompleted: completedSet.contains(day),
        );
      }).toList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> completeChallenge(int day) async {
    try {
      final completedDays =
          sharedPreferences.getStringList(_completedChallengesKey) ?? [];
      if (!completedDays.contains(day.toString())) {
        completedDays.add(day.toString());
        await sharedPreferences.setStringList(
          _completedChallengesKey,
          completedDays,
        );
      }
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> uncompleteChallenge(int day) async {
    try {
      final completedDays =
          sharedPreferences.getStringList(_completedChallengesKey) ?? [];
      if (completedDays.contains(day.toString())) {
        completedDays.remove(day.toString());
        await sharedPreferences.setStringList(
          _completedChallengesKey,
          completedDays,
        );
      }
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<bool> isChallengeCompleted(int day) async {
    final completedDays =
        sharedPreferences.getStringList(_completedChallengesKey) ?? [];
    return completedDays.contains(day.toString());
  }
}
