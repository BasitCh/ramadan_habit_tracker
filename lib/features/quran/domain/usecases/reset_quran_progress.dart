import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';

class ResetQuranProgress implements UseCase<QuranProgress, NoParams> {
  final QuranRepository repository;

  ResetQuranProgress(this.repository);

  @override
  Future<Either<Failure, QuranProgress>> call(NoParams params) async {
    return await repository.resetProgress();
  }
}
