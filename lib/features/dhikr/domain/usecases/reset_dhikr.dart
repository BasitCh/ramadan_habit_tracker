import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/entities/dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/repositories/dhikr_repository.dart';

class ResetDhikr extends UseCase<Dhikr, String> {
  final DhikrRepository repository;

  ResetDhikr(this.repository);

  @override
  Future<Either<Failure, Dhikr>> call(String params) {
    return repository.resetDhikr(params);
  }
}
