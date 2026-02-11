import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/entities/fasting_day.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/usecases/get_fasting_logs.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/usecases/toggle_fasting.dart';

part 'fasting_event.dart';
part 'fasting_state.dart';

class FastingBloc extends Bloc<FastingEvent, FastingState> {
  final GetFastingLogs getFastingLogs;
  final ToggleFasting toggleFasting;

  FastingBloc({
    required this.getFastingLogs,
    required this.toggleFasting,
  }) : super(const FastingInitial()) {
    on<LoadFastingLogs>(_onLoadFastingLogs);
    on<ToggleFastingRequested>(_onToggleFasting);
  }

  Future<void> _onLoadFastingLogs(
    LoadFastingLogs event,
    Emitter<FastingState> emit,
  ) async {
    emit(const FastingLoading());
    final result = await getFastingLogs(const NoParams());
    result.fold(
      (failure) => emit(FastingError(failure.message)),
      (days) => emit(FastingLoaded(days)),
    );
  }

  Future<void> _onToggleFasting(
    ToggleFastingRequested event,
    Emitter<FastingState> emit,
  ) async {
    final result = await toggleFasting(event.date);
    result.fold(
      (failure) => emit(FastingError(failure.message)),
      (_) => add(const LoadFastingLogs()),
    );
  }
}
