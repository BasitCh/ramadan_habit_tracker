import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/entities/dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/usecases/add_dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/usecases/get_dhikr_list.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/usecases/increment_dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/usecases/reset_dhikr.dart';
import 'package:uuid/uuid.dart';

part 'dhikr_event.dart';
part 'dhikr_state.dart';

class DhikrBloc extends Bloc<DhikrEvent, DhikrState> {
  final GetDhikrList getDhikrList;
  final IncrementDhikr incrementDhikr;
  final ResetDhikr resetDhikr;
  final AddDhikr addDhikr;
  final Uuid uuid;

  DhikrBloc({
    required this.getDhikrList,
    required this.incrementDhikr,
    required this.resetDhikr,
    required this.addDhikr,
    required this.uuid,
  }) : super(const DhikrInitial()) {
    on<LoadDhikrList>(_onLoadDhikrList);
    on<IncrementDhikrRequested>(_onIncrementDhikr);
    on<ResetDhikrRequested>(_onResetDhikr);
    on<AddDhikrRequested>(_onAddDhikr);
  }

  Future<void> _onLoadDhikrList(
    LoadDhikrList event,
    Emitter<DhikrState> emit,
  ) async {
    emit(const DhikrLoading());
    final result = await getDhikrList(const NoParams());
    result.fold(
      (failure) => emit(DhikrError(failure.message)),
      (list) => emit(DhikrLoaded(list)),
    );
  }

  Future<void> _onIncrementDhikr(
    IncrementDhikrRequested event,
    Emitter<DhikrState> emit,
  ) async {
    final result = await incrementDhikr(event.dhikrId);
    result.fold(
      (failure) => emit(DhikrError(failure.message)),
      (_) => add(const LoadDhikrList()),
    );
  }

  Future<void> _onResetDhikr(
    ResetDhikrRequested event,
    Emitter<DhikrState> emit,
  ) async {
    final result = await resetDhikr(event.dhikrId);
    result.fold(
      (failure) => emit(DhikrError(failure.message)),
      (_) => add(const LoadDhikrList()),
    );
  }

  Future<void> _onAddDhikr(
    AddDhikrRequested event,
    Emitter<DhikrState> emit,
  ) async {
    final dhikr = Dhikr(
      id: uuid.v4(),
      name: event.name,
      targetCount: event.targetCount,
      currentCount: 0,
    );
    final result = await addDhikr(dhikr);
    result.fold(
      (failure) => emit(DhikrError(failure.message)),
      (_) => add(const LoadDhikrList()),
    );
  }
}
