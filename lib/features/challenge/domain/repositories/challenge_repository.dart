import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/challenge/data/models/challenge_model.dart';

abstract class ChallengeRepository {
  Future<Either<Failure, List<ChallengeModel>>> getChallenges();
  Future<Either<Failure, void>> completeChallenge(int day);
  Future<Either<Failure, void>> uncompleteChallenge(int day);
  Future<Either<Failure, bool>> isChallengeCompleted(int day);
}
