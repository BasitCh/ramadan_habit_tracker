import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/entities/ibadah_checklist.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/usecases/get_ibadah_checklist.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/usecases/toggle_ibadah_item.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/repositories/ibadah_repository.dart';

// ── Events ──────────────────────────────────────────────────────────────────

sealed class IbadahEvent extends Equatable {
  const IbadahEvent();
  @override
  List<Object?> get props => [];
}

class LoadIbadahChecklistRequested extends IbadahEvent {
  const LoadIbadahChecklistRequested();
}

class ToggleIbadahItemRequested extends IbadahEvent {
  final String item;
  const ToggleIbadahItemRequested(this.item);
  @override
  List<Object> get props => [item];
}

// ── States ──────────────────────────────────────────────────────────────────

sealed class IbadahState extends Equatable {
  const IbadahState();
  @override
  List<Object?> get props => [];
}

class IbadahInitial extends IbadahState {
  const IbadahInitial();
}

class IbadahLoading extends IbadahState {
  const IbadahLoading();
}

class IbadahLoaded extends IbadahState {
  final IbadahChecklist checklist;
  final int totalCharityActs;

  const IbadahLoaded(this.checklist, {this.totalCharityActs = 0});

  IbadahLoaded copyWith({IbadahChecklist? checklist, int? totalCharityActs}) {
    return IbadahLoaded(
      checklist ?? this.checklist,
      totalCharityActs: totalCharityActs ?? this.totalCharityActs,
    );
  }

  @override
  List<Object> get props => [checklist, totalCharityActs];
}

class IbadahError extends IbadahState {
  final String message;
  const IbadahError(this.message);
  @override
  List<Object> get props => [message];
}

// ── Bloc ────────────────────────────────────────────────────────────────────

class IbadahBloc extends Bloc<IbadahEvent, IbadahState> {
  final GetIbadahChecklist getChecklist;
  final ToggleIbadahItem toggleItem;
  final IbadahRepository repository;

  IbadahBloc({
    required this.getChecklist,
    required this.toggleItem,
    required this.repository,
  }) : super(const IbadahInitial()) {
    on<LoadIbadahChecklistRequested>(_onLoad);
    on<ToggleIbadahItemRequested>(_onToggle);
  }

  Future<void> _onLoad(
    LoadIbadahChecklistRequested event,
    Emitter<IbadahState> emit,
  ) async {
    emit(const IbadahLoading());
    final result = await getChecklist(
      GetIbadahChecklistParams(date: DateTime.now()),
    );

    await result.fold((f) async => emit(IbadahError(f.message)), (
      checklist,
    ) async {
      final statsResult = await repository.getTotalCharityCount();
      final stats = statsResult.getOrElse(() => 0);
      emit(IbadahLoaded(checklist, totalCharityActs: stats));
    });
  }

  Future<void> _onToggle(
    ToggleIbadahItemRequested event,
    Emitter<IbadahState> emit,
  ) async {
    final result = await toggleItem(
      ToggleIbadahItemParams(date: DateTime.now(), item: event.item),
    );

    await result.fold((f) async => emit(IbadahError(f.message)), (
      checklist,
    ) async {
      final statsResult = await repository.getTotalCharityCount();
      final stats = statsResult.getOrElse(() => 0);
      emit(IbadahLoaded(checklist, totalCharityActs: stats));
    });
  }
}
