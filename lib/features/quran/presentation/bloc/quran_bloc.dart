import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/update_pages_read.dart';

// ── Events ──────────────────────────────────────────────────────────────────

sealed class QuranEvent extends Equatable {
  const QuranEvent();
  @override
  List<Object?> get props => [];
}

class LoadQuranProgressRequested extends QuranEvent {
  const LoadQuranProgressRequested();
}

class UpdatePagesReadRequested extends QuranEvent {
  final int pages;
  const UpdatePagesReadRequested(this.pages);
  @override
  List<Object> get props => [pages];
}

// ── States ──────────────────────────────────────────────────────────────────

sealed class QuranState extends Equatable {
  const QuranState();
  @override
  List<Object?> get props => [];
}

class QuranInitial extends QuranState {
  const QuranInitial();
}

class QuranLoading extends QuranState {
  const QuranLoading();
}

class QuranLoaded extends QuranState {
  final QuranProgress progress;
  const QuranLoaded(this.progress);
  @override
  List<Object> get props => [progress];
}

class QuranError extends QuranState {
  final String message;
  const QuranError(this.message);
  @override
  List<Object> get props => [message];
}

// ── Bloc ────────────────────────────────────────────────────────────────────

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final GetQuranProgress getQuranProgress;
  final UpdatePagesRead updatePagesRead;

  QuranBloc({
    required this.getQuranProgress,
    required this.updatePagesRead,
  }) : super(const QuranInitial()) {
    on<LoadQuranProgressRequested>(_onLoad);
    on<UpdatePagesReadRequested>(_onUpdate);
  }

  Future<void> _onLoad(LoadQuranProgressRequested event, Emitter<QuranState> emit) async {
    emit(const QuranLoading());
    final result = await getQuranProgress(const NoParams());
    result.fold(
      (f) => emit(QuranError(f.message)),
      (p) => emit(QuranLoaded(p)),
    );
  }

  Future<void> _onUpdate(UpdatePagesReadRequested event, Emitter<QuranState> emit) async {
    final result = await updatePagesRead(UpdatePagesParams(pages: event.pages));
    result.fold(
      (f) => emit(QuranError(f.message)),
      (p) => emit(QuranLoaded(p)),
    );
  }
}
