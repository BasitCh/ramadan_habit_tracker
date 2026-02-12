import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';

class GetQuranProgress extends UseCase<QuranProgress, NoParams> {
  final QuranRepository repository;

  GetQuranProgress(this.repository);

  @override
  Future<Either<Failure, QuranProgress>> call(NoParams params) {
    return repository.getProgress();
  }
}
