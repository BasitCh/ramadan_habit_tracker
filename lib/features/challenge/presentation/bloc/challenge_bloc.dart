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

class LoadDailyChallengeRequested extends ChallengeEvent {
  final int day;

  const LoadDailyChallengeRequested(this.day);

  @override
  List<Object> get props => [day];
}

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
  final ChallengeModel challenge;

  const ChallengeLoaded(this.challenge);

  @override
  List<Object> get props => [challenge];
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
    on<LoadDailyChallengeRequested>(_onLoadDailyChallenge);
    on<CompleteChallengeRequested>(_onCompleteChallenge);
    on<UncompleteChallengeRequested>(_onUncompleteChallenge);
  }

  Future<void> _onLoadDailyChallenge(
    LoadDailyChallengeRequested event,
    Emitter<ChallengeState> emit,
  ) async {
    emit(ChallengeLoading());
    // 1. Get content based on modulo
    // 2. Get status based on absolute day

    // Logic: (day - 1) % 30 + 1
    // Day 1 -> 1, Day 30 -> 30, Day 31 -> 1
    int effectiveDay = (event.day - 1) % 30 + 1;
    if (effectiveDay == 0)
      effectiveDay = 30; // Should not happen with above math but safe guard

    // We need a method to get specific challenge content.
    // The repo currently returns a list.
    // Let's modify the repo/datasource to get single challenge or just fetch all and pick one.
    // Fetching all 30 is cheap.

    final result = await repository.getChallenges();
    await result.fold(
      (failure) async => emit(ChallengeError(failure.message)),
      (challenges) async {
        final content = challenges.firstWhere(
          (c) => c.day == effectiveDay,
          orElse: () => challenges.first,
        );

        // Now check real status for absolute day
        final statusResult = await repository.isChallengeCompleted(event.day);
        statusResult.fold((failure) => emit(ChallengeError(failure.message)), (
          isCompleted,
        ) {
          emit(
            ChallengeLoaded(
              content.copyWith(
                day: event.day, // Use absolute day for UI
                isCompleted: isCompleted,
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _onCompleteChallenge(
    CompleteChallengeRequested event,
    Emitter<ChallengeState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChallengeLoaded) {
      // Optimistic update
      emit(ChallengeLoaded(currentState.challenge.copyWith(isCompleted: true)));

      final result = await repository.completeChallenge(event.day);
      result.fold((failure) {
        emit(ChallengeError(failure.message));
        add(LoadDailyChallengeRequested(event.day));
      }, (_) => null);
    }
  }

  Future<void> _onUncompleteChallenge(
    UncompleteChallengeRequested event,
    Emitter<ChallengeState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChallengeLoaded) {
      // Optimistic update
      emit(
        ChallengeLoaded(currentState.challenge.copyWith(isCompleted: false)),
      );

      final result = await repository.uncompleteChallenge(event.day);
      result.fold((failure) {
        emit(ChallengeError(failure.message));
        add(LoadDailyChallengeRequested(event.day));
      }, (_) => null);
    }
  }
}
