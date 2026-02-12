import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/entities/dua.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/repositories/dua_repository.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/usecases/get_daily_dua.dart';

// ── Events ──────────────────────────────────────────────────────────────────

sealed class DuaEvent extends Equatable {
  const DuaEvent();
  @override
  List<Object?> get props => [];
}

class LoadDailyDuaRequested extends DuaEvent {
  const LoadDailyDuaRequested();
}

class ToggleBookmarkRequested extends DuaEvent {
  final String duaId;
  const ToggleBookmarkRequested(this.duaId);
  @override
  List<Object> get props => [duaId];
}

class MarkAsRecitedRequested extends DuaEvent {
  final String duaId;
  const MarkAsRecitedRequested(this.duaId);
  @override
  List<Object> get props => [duaId];
}

// ── States ──────────────────────────────────────────────────────────────────

sealed class DuaState extends Equatable {
  const DuaState();
  @override
  List<Object?> get props => [];
}

class DuaInitial extends DuaState {
  const DuaInitial();
}

class DuaLoading extends DuaState {
  const DuaLoading();
}

class DuaLoaded extends DuaState {
  final Dua dua;
  const DuaLoaded(this.dua);
  @override
  List<Object> get props => [dua];
}

class DuaError extends DuaState {
  final String message;
  const DuaError(this.message);
  @override
  List<Object> get props => [message];
}

// ── Bloc ────────────────────────────────────────────────────────────────────

class DuaBloc extends Bloc<DuaEvent, DuaState> {
  final GetDailyDua getDailyDua;
  final DuaRepository repository;

  DuaBloc({required this.getDailyDua, required this.repository}) : super(const DuaInitial()) {
    on<LoadDailyDuaRequested>(_onLoad);
    on<ToggleBookmarkRequested>(_onToggleBookmark);
    on<MarkAsRecitedRequested>(_onMarkRecited);
  }

  Future<void> _onLoad(LoadDailyDuaRequested event, Emitter<DuaState> emit) async {
    emit(const DuaLoading());
    final result = await getDailyDua(const NoParams());
    result.fold(
      (f) => emit(DuaError(f.message)),
      (dua) => emit(DuaLoaded(dua)),
    );
  }

  Future<void> _onToggleBookmark(ToggleBookmarkRequested event, Emitter<DuaState> emit) async {
    await repository.toggleBookmark(event.duaId);
    add(const LoadDailyDuaRequested());
  }

  Future<void> _onMarkRecited(MarkAsRecitedRequested event, Emitter<DuaState> emit) async {
    await repository.markAsRecited(event.duaId);
    add(const LoadDailyDuaRequested());
  }
}
