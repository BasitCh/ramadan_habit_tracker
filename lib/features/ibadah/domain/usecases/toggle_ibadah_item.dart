import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/entities/ibadah_checklist.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/repositories/ibadah_repository.dart';

class ToggleIbadahItem extends UseCase<IbadahChecklist, ToggleIbadahItemParams> {
  final IbadahRepository repository;

  ToggleIbadahItem(this.repository);

  @override
  Future<Either<Failure, IbadahChecklist>> call(ToggleIbadahItemParams params) {
    return repository.toggleItem(params.date, params.item);
  }
}

class ToggleIbadahItemParams extends Equatable {
  final DateTime date;
  final String item;

  const ToggleIbadahItemParams({
    required this.date,
    required this.item,
  });

  @override
  List<Object> get props => [date, item];
}
