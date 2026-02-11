import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/entities/dhikr.dart';

abstract class DhikrRepository {
  Future<Either<Failure, List<Dhikr>>> getDhikrList();
  Future<Either<Failure, Dhikr>> incrementDhikr(String id);
  Future<Either<Failure, Dhikr>> resetDhikr(String id);
  Future<Either<Failure, Dhikr>> addDhikr(Dhikr dhikr);
}
