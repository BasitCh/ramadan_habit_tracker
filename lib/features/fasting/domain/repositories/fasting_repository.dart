import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/entities/fasting_day.dart';

abstract class FastingRepository {
  Future<Either<Failure, List<FastingDay>>> getFastingLogs();
  Future<Either<Failure, FastingDay>> toggleFasting(DateTime date);
}
