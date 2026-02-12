import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/adhkar/domain/entities/adhkar.dart';

abstract class AdhkarRepository {
  Future<Either<Failure, List<Adhkar>>> getAdhkarByCategory(String category);
  Future<Either<Failure, Adhkar>> incrementAdhkar(String adhkarId);
  Future<Either<Failure, void>> resetDailyProgress();
}
