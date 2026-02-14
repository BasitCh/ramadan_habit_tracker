import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/entities/hadith.dart';

abstract class HadithRepository {
  Future<Either<Failure, Hadith>> getDailyHadith();
}
