import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Events ───────────────────────────────────────────────────────────────────

sealed class TasbeehEvent extends Equatable {
  const TasbeehEvent();
  @override
  List<Object?> get props => [];
}

class TasbeehLoadRequested extends TasbeehEvent {
  const TasbeehLoadRequested();
}

class TasbeehIncrementRequested extends TasbeehEvent {
  const TasbeehIncrementRequested();
}

class TasbeehResetRequested extends TasbeehEvent {
  const TasbeehResetRequested();
}

class TasbeehLimitSetRequested extends TasbeehEvent {
  final int limit;
  const TasbeehLimitSetRequested(this.limit);
  @override
  List<Object?> get props => [limit];
}

class TasbeehPressChanged extends TasbeehEvent {
  final bool isPressed;
  const TasbeehPressChanged(this.isPressed);
  @override
  List<Object?> get props => [isPressed];
}

// ── State ────────────────────────────────────────────────────────────────────

class TasbeehState extends Equatable {
  final int count;
  final int cycle;
  final int limit;
  final bool isPressed;

  const TasbeehState({
    this.count = 0,
    this.cycle = 0,
    this.limit = 33,
    this.isPressed = false,
  });

  TasbeehState copyWith({
    int? count,
    int? cycle,
    int? limit,
    bool? isPressed,
  }) {
    return TasbeehState(
      count: count ?? this.count,
      cycle: cycle ?? this.cycle,
      limit: limit ?? this.limit,
      isPressed: isPressed ?? this.isPressed,
    );
  }

  @override
  List<Object?> get props => [count, cycle, limit, isPressed];
}

// ── Bloc ─────────────────────────────────────────────────────────────────────

class TasbeehBloc extends Bloc<TasbeehEvent, TasbeehState> {
  final SharedPreferences sharedPreferences;

  static const _keyCount = 'tasbeeh_count';
  static const _keyCycle = 'tasbeeh_cycle';
  static const _keyLimit = 'tasbeeh_limit';

  TasbeehBloc({required this.sharedPreferences})
      : super(const TasbeehState()) {
    on<TasbeehLoadRequested>(_onLoad);
    on<TasbeehIncrementRequested>(_onIncrement);
    on<TasbeehResetRequested>(_onReset);
    on<TasbeehLimitSetRequested>(_onSetLimit);
    on<TasbeehPressChanged>(_onPressChanged);
  }

  Future<void> _onLoad(
    TasbeehLoadRequested event,
    Emitter<TasbeehState> emit,
  ) async {
    final count = sharedPreferences.getInt(_keyCount) ?? 0;
    final cycle = sharedPreferences.getInt(_keyCycle) ?? 0;
    final limit = sharedPreferences.getInt(_keyLimit) ?? 33;
    emit(state.copyWith(count: count, cycle: cycle, limit: limit));
  }

  Future<void> _onIncrement(
    TasbeehIncrementRequested event,
    Emitter<TasbeehState> emit,
  ) async {
    final newCount = state.count + 1;
    final completedCycle = newCount % state.limit == 0;
    final newCycle = state.cycle + (completedCycle ? 1 : 0);
    emit(state.copyWith(count: newCount, cycle: newCycle));
    await _save(newCount, newCycle, state.limit);
  }

  Future<void> _onReset(
    TasbeehResetRequested event,
    Emitter<TasbeehState> emit,
  ) async {
    emit(state.copyWith(count: 0, cycle: 0));
    await _save(0, 0, state.limit);
  }

  Future<void> _onSetLimit(
    TasbeehLimitSetRequested event,
    Emitter<TasbeehState> emit,
  ) async {
    emit(state.copyWith(limit: event.limit));
    await _save(state.count, state.cycle, event.limit);
  }

  void _onPressChanged(
    TasbeehPressChanged event,
    Emitter<TasbeehState> emit,
  ) {
    emit(state.copyWith(isPressed: event.isPressed));
  }

  Future<void> _save(int count, int cycle, int limit) async {
    await sharedPreferences.setInt(_keyCount, count);
    await sharedPreferences.setInt(_keyCycle, cycle);
    await sharedPreferences.setInt(_keyLimit, limit);
  }
}
