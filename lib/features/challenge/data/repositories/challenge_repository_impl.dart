import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/challenge/data/datasources/challenge_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/challenge/data/models/challenge_model.dart';
import 'package:ramadan_habit_tracker/features/challenge/domain/repositories/challenge_repository.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  final ChallengeLocalDataSource localDataSource;

  ChallengeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ChallengeModel>>> getChallenges() async {
    try {
      final challenges = await localDataSource.getChallenges();
      return Right(challenges);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> completeChallenge(int day) async {
    try {
      await localDataSource.completeChallenge(day);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> uncompleteChallenge(int day) async {
    try {
      await localDataSource.uncompleteChallenge(day);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isChallengeCompleted(int day) async {
    try {
      final result = await localDataSource.isChallengeCompleted(day);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
