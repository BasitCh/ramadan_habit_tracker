import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';

abstract class QuranRepository {
  Future<Either<Failure, QuranProgress>> getProgress();
  Future<Either<Failure, QuranProgress>> updatePagesRead(int pages);
}
