part of 'dhikr_bloc.dart';

sealed class DhikrState extends Equatable {
  const DhikrState();

  @override
  List<Object> get props => [];
}

class DhikrInitial extends DhikrState {
  const DhikrInitial();
}

class DhikrLoading extends DhikrState {
  const DhikrLoading();
}

class DhikrLoaded extends DhikrState {
  final List<Dhikr> dhikrList;

  const DhikrLoaded(this.dhikrList);

  @override
  List<Object> get props => [dhikrList];
}

class DhikrError extends DhikrState {
  final String message;

  const DhikrError(this.message);

  @override
  List<Object> get props => [message];
}
