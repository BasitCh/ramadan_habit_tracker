import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/entities/fasting_day.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/repositories/fasting_repository.dart';

class GetFastingLogs extends UseCase<List<FastingDay>, NoParams> {
  final FastingRepository repository;

  GetFastingLogs(this.repository);

  @override
  Future<Either<Failure, List<FastingDay>>> call(NoParams params) {
    return repository.getFastingLogs();
  }
}
