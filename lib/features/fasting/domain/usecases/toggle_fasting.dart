import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/entities/fasting_day.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/repositories/fasting_repository.dart';

class ToggleFasting extends UseCase<FastingDay, DateTime> {
  final FastingRepository repository;

  ToggleFasting(this.repository);

  @override
  Future<Either<Failure, FastingDay>> call(DateTime params) {
    return repository.toggleFasting(params);
  }
}
