part of 'dhikr_bloc.dart';

sealed class DhikrEvent extends Equatable {
  const DhikrEvent();

  @override
  List<Object?> get props => [];
}

class LoadDhikrList extends DhikrEvent {
  const LoadDhikrList();
}

class IncrementDhikrRequested extends DhikrEvent {
  final String dhikrId;

  const IncrementDhikrRequested(this.dhikrId);

  @override
  List<Object?> get props => [dhikrId];
}

class ResetDhikrRequested extends DhikrEvent {
  final String dhikrId;

  const ResetDhikrRequested(this.dhikrId);

  @override
  List<Object?> get props => [dhikrId];
}

class AddDhikrRequested extends DhikrEvent {
  final String name;
  final int targetCount;

  const AddDhikrRequested({required this.name, required this.targetCount});

  @override
  List<Object?> get props => [name, targetCount];
}
