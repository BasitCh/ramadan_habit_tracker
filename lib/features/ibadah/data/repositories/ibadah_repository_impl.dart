import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/ibadah/data/datasources/ibadah_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/entities/ibadah_checklist.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/repositories/ibadah_repository.dart';

class IbadahRepositoryImpl implements IbadahRepository {
  final IbadahLocalDataSource localDataSource;

  IbadahRepositoryImpl({required this.localDataSource});

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<Either<Failure, IbadahChecklist>> getChecklist(DateTime date) async {
    try {
      final model = await localDataSource.getChecklist(_dateKey(date));
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, IbadahChecklist>> toggleItem(
    DateTime date,
    String item,
  ) async {
    try {
      final model = await localDataSource.toggleItem(_dateKey(date), item);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalCharityCount() async {
    try {
      final count = await localDataSource.getTotalCharityCount();
      return Right(count);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
