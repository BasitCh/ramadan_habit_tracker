import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/features/adhkar/domain/entities/adhkar.dart';
import 'package:ramadan_habit_tracker/features/adhkar/domain/repositories/adhkar_repository.dart';

// ── Events ──────────────────────────────────────────────────────────────────

sealed class AdhkarEvent extends Equatable {
  const AdhkarEvent();
  @override
  List<Object?> get props => [];
}

class LoadAdhkarRequested extends AdhkarEvent {
  final String category;
  const LoadAdhkarRequested(this.category);
  @override
  List<Object> get props => [category];
}

class IncrementAdhkarRequested extends AdhkarEvent {
  final String adhkarId;
  const IncrementAdhkarRequested(this.adhkarId);
  @override
  List<Object> get props => [adhkarId];
}

// ── States ──────────────────────────────────────────────────────────────────

sealed class AdhkarState extends Equatable {
  const AdhkarState();
  @override
  List<Object?> get props => [];
}

class AdhkarInitial extends AdhkarState {
  const AdhkarInitial();
}

class AdhkarLoading extends AdhkarState {
  const AdhkarLoading();
}

class AdhkarLoaded extends AdhkarState {
  final List<Adhkar> adhkarList;
  final String category;

  const AdhkarLoaded({required this.adhkarList, required this.category});

  int get completedCount => adhkarList.where((a) => a.isCompleted).length;
  int get totalCount => adhkarList.length;

  @override
  List<Object> get props => [adhkarList, category];
}

class AdhkarError extends AdhkarState {
  final String message;
  const AdhkarError(this.message);
  @override
  List<Object> get props => [message];
}

// ── Bloc ────────────────────────────────────────────────────────────────────

class AdhkarBloc extends Bloc<AdhkarEvent, AdhkarState> {
  final AdhkarRepository repository;

  AdhkarBloc({required this.repository}) : super(const AdhkarInitial()) {
    on<LoadAdhkarRequested>(_onLoad);
    on<IncrementAdhkarRequested>(_onIncrement);
  }

  Future<void> _onLoad(LoadAdhkarRequested event, Emitter<AdhkarState> emit) async {
    emit(const AdhkarLoading());
    final result = await repository.getAdhkarByCategory(event.category);
    result.fold(
      (f) => emit(AdhkarError(f.message)),
      (list) => emit(AdhkarLoaded(adhkarList: list, category: event.category)),
    );
  }

  Future<void> _onIncrement(IncrementAdhkarRequested event, Emitter<AdhkarState> emit) async {
    final currentState = state;
    if (currentState is! AdhkarLoaded) return;

    final result = await repository.incrementAdhkar(event.adhkarId);
    result.fold(
      (f) => emit(AdhkarError(f.message)),
      (updated) {
        final updatedList = currentState.adhkarList.map((a) {
          return a.id == updated.id ? updated : a;
        }).toList();
        emit(AdhkarLoaded(adhkarList: updatedList, category: currentState.category));
      },
    );
  }
}
