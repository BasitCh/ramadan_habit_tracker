import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';

class GetSurahList extends UseCase<List<Surah>, NoParams> {
  final QuranRepository repository;

  GetSurahList(this.repository);

  @override
  Future<Either<Failure, List<Surah>>> call(NoParams params) {
    return repository.getSurahList();
  }
}
