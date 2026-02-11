import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';

class UpdateQuranProgress extends UseCase<QuranProgress, QuranProgress> {
  final QuranRepository repository;

  UpdateQuranProgress(this.repository);

  @override
  Future<Either<Failure, QuranProgress>> call(QuranProgress params) {
    return repository.updateQuranProgress(params);
  }
}
