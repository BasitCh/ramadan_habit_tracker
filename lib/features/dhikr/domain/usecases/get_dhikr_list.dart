import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/entities/dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/repositories/dhikr_repository.dart';

class GetDhikrList extends UseCase<List<Dhikr>, NoParams> {
  final DhikrRepository repository;

  GetDhikrList(this.repository);

  @override
  Future<Either<Failure, List<Dhikr>>> call(NoParams params) {
    return repository.getDhikrList();
  }
}
