import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/entities/ibadah_checklist.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/repositories/ibadah_repository.dart';

class GetIbadahChecklist
    extends UseCase<IbadahChecklist, GetIbadahChecklistParams> {
  final IbadahRepository repository;

  GetIbadahChecklist(this.repository);

  @override
  Future<Either<Failure, IbadahChecklist>> call(
    GetIbadahChecklistParams params,
  ) {
    return repository.getChecklist(params.date);
  }
}

class GetIbadahChecklistParams extends Equatable {
  final DateTime date;

  const GetIbadahChecklistParams({required this.date});

  @override
  List<Object> get props => [date];
}
