import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';

class UpdatePagesRead extends UseCase<QuranProgress, UpdatePagesParams> {
  final QuranRepository repository;

  UpdatePagesRead(this.repository);

  @override
  Future<Either<Failure, QuranProgress>> call(UpdatePagesParams params) {
    return repository.updatePagesRead(params.pages);
  }
}

class UpdatePagesParams {
  final int pages;
  const UpdatePagesParams({required this.pages});
}
