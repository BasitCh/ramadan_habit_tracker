import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/repositories/habit_repository.dart';

class DeleteHabit extends UseCase<void, String> {
  final HabitRepository repository;

  DeleteHabit(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteHabit(params);
  }
}
