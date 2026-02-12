import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/entities/dua.dart';

abstract class DuaRepository {
  Future<Either<Failure, Dua>> getDailyDua();
  Future<Either<Failure, void>> toggleBookmark(String duaId);
  Future<Either<Failure, void>> markAsRecited(String duaId);
  Future<Either<Failure, List<Dua>>> getBookmarkedDuas();
}
