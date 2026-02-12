import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/entities/dua.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/repositories/dua_repository.dart';

class GetDailyDua extends UseCase<Dua, NoParams> {
  final DuaRepository repository;
  GetDailyDua(this.repository);

  @override
  Future<Either<Failure, Dua>> call(NoParams params) => repository.getDailyDua();
}
