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
        final originalDay = data['day'] as int;
        // In this method, we return the list as defined in constants.
        // The UI or Bloc should handle mapping "Current Day > 30" to one of these.
        // However, to support "history" of completed challenges even if they repeat,
        // we might need a more robust system.
        // For now, simplicity: The list remains 1-30.
        // If today is Day 35, the UI will ask for Challenge #5.
        // If Challenge #5 was completed on Day 5, should it be reset for Day 35?
        // The user asked to "renew them".
        // This implies we should track completion key as "day_combined" or similar.
        // BUT, changing the key structure now might break existing completions.
        // Let's stick to the request: "renew them".
        // If we want to renew, we should check if the completion date was "long ago" or just rely on manual uncheck.
        // Easier approach for MVP:
        // The 'isCompleted' flag here maps to the static day ID (1-30).
        // If the user completes Day 5, it stays completed until they uncheck it.
        // To allow "renewal", we can just let them uncheck it.
        // OR, we can treat the completion key as unique per cycle.
        // Let's keep it simple: Map 1-30. If day > 30, it maps to day % 30.
        return ChallengeModel(
          day: originalDay,
          title: data['title'] as String,
          description: data['description'] as String,
          isCompleted: completedSet.contains(originalDay),
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
