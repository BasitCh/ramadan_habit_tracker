import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah_detail.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';

class GetSurahDetail extends UseCase<SurahDetail, GetSurahDetailParams> {
  final QuranRepository repository;

  GetSurahDetail(this.repository);

  @override
  Future<Either<Failure, SurahDetail>> call(GetSurahDetailParams params) {
    return repository.getSurahDetail(params.surahNumber);
  }
}

class GetSurahDetailParams extends Equatable {
  final int surahNumber;

  const GetSurahDetailParams({required this.surahNumber});

  @override
  List<Object> get props => [surahNumber];
}
