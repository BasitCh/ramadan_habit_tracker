import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah_detail.dart';

abstract class QuranRepository {
  Future<Either<Failure, QuranProgress>> getProgress();
  Future<Either<Failure, QuranProgress>> updatePagesRead(int pages);
  Future<Either<Failure, List<Surah>>> getSurahList();
  Future<Either<Failure, SurahDetail>> getSurahDetail(int surahNumber);
  Future<Either<Failure, QuranProgress>> resetProgress();
}
