import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/entities/dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/repositories/dhikr_repository.dart';

class AddDhikr extends UseCase<Dhikr, Dhikr> {
  final DhikrRepository repository;

  AddDhikr(this.repository);

  @override
  Future<Either<Failure, Dhikr>> call(Dhikr params) {
    return repository.addDhikr(params);
  }
}
