import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/entities/ibadah_checklist.dart';

abstract class IbadahRepository {
  Future<Either<Failure, IbadahChecklist>> getChecklist(DateTime date);
  Future<Either<Failure, IbadahChecklist>> toggleItem(
    DateTime date,
    String item,
  );
  Future<Either<Failure, int>> getTotalCharityCount();
}
