import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/features/challenge/data/models/challenge_model.dart';
import 'package:ramadan_habit_tracker/features/challenge/domain/repositories/challenge_repository.dart';

// Events
abstract class ChallengeEvent extends Equatable {
  const ChallengeEvent();

  @override
  List<Object> get props => [];
}

class LoadChallengesRequested extends ChallengeEvent {}

class CompleteChallengeRequested extends ChallengeEvent {
  final int day;

  const CompleteChallengeRequested(this.day);

  @override
  List<Object> get props => [day];
}

class UncompleteChallengeRequested extends ChallengeEvent {
  final int day;

  const UncompleteChallengeRequested(this.day);

  @override
  List<Object> get props => [day];
}

// States
abstract class ChallengeState extends Equatable {
  const ChallengeState();

  @override
  List<Object> get props => [];
}

class ChallengeInitial extends ChallengeState {}

class ChallengeLoading extends ChallengeState {}

class ChallengeLoaded extends ChallengeState {
  final List<ChallengeModel> challenges;

  const ChallengeLoaded(this.challenges);

  @override
  List<Object> get props => [challenges];

  bool get isAllCompleted => challenges.every((c) => c.isCompleted);
  int get completedCount => challenges.where((c) => c.isCompleted).length;
}

class ChallengeError extends ChallengeState {
  final String message;

  const ChallengeError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository repository;

  ChallengeBloc({required this.repository}) : super(ChallengeInitial()) {
    on<LoadChallengesRequested>(_onLoadChallenges);
    on<CompleteChallengeRequested>(_onCompleteChallenge);
    on<UncompleteChallengeRequested>(_onUncompleteChallenge);
  }

  Future<void> _onLoadChallenges(
    LoadChallengesRequested event,
    Emitter<ChallengeState> emit,
  ) async {
    emit(ChallengeLoading());
    final result = await repository.getChallenges();
    result.fold(
      (failure) => emit(ChallengeError(failure.message)),
      (challenges) => emit(ChallengeLoaded(challenges)),
    );
  }

  Future<void> _onCompleteChallenge(
    CompleteChallengeRequested event,
    Emitter<ChallengeState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChallengeLoaded) {
      // Optimistic update
      final updatedChallenges = currentState.challenges.map((c) {
        if (c.day == event.day) {
          return c.copyWith(isCompleted: true);
        }
        return c;
      }).toList();
      emit(ChallengeLoaded(updatedChallenges));

      final result = await repository.completeChallenge(event.day);
      result.fold(
        (failure) {
          // Revert on failure
          emit(ChallengeError(failure.message));
          add(LoadChallengesRequested()); // Reload to ensure consistency
        },
        (_) => null, // Success, state already updated
      );
    }
  }

  Future<void> _onUncompleteChallenge(
    UncompleteChallengeRequested event,
    Emitter<ChallengeState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChallengeLoaded) {
      // Optimistic update
      final updatedChallenges = currentState.challenges.map((c) {
        if (c.day == event.day) {
          return c.copyWith(isCompleted: false);
        }
        return c;
      }).toList();
      emit(ChallengeLoaded(updatedChallenges));

      final result = await repository.uncompleteChallenge(event.day);
      result.fold((failure) {
        // Revert on failure
        emit(ChallengeError(failure.message));
        add(LoadChallengesRequested());
      }, (_) => null);
    }
  }
}
