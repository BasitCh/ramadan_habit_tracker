import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/entities/hadith.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/repositories/hadith_repository.dart';

class GetDailyHadith extends UseCase<Hadith, NoParams> {
  final HadithRepository repository;

  GetDailyHadith(this.repository);

  @override
  Future<Either<Failure, Hadith>> call(NoParams params) {
    return repository.getDailyHadith();
  }
}
