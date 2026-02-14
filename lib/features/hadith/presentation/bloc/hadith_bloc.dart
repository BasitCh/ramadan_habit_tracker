import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/entities/hadith.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/usecases/get_daily_hadith.dart';

// ── Events ──────────────────────────────────────────────────────────────────

sealed class HadithEvent extends Equatable {
  const HadithEvent();
  @override
  List<Object?> get props => [];
}

class LoadDailyHadithRequested extends HadithEvent {
  const LoadDailyHadithRequested();
}

// ── States ──────────────────────────────────────────────────────────────────

sealed class HadithState extends Equatable {
  const HadithState();
  @override
  List<Object?> get props => [];
}

class HadithInitial extends HadithState {
  const HadithInitial();
}

class HadithLoading extends HadithState {
  const HadithLoading();
}

class HadithLoaded extends HadithState {
  final Hadith hadith;
  const HadithLoaded(this.hadith);
  @override
  List<Object> get props => [hadith];
}

class HadithError extends HadithState {
  final String message;
  const HadithError(this.message);
  @override
  List<Object> get props => [message];
}

// ── Bloc ────────────────────────────────────────────────────────────────────

class HadithBloc extends Bloc<HadithEvent, HadithState> {
  final GetDailyHadith getDailyHadith;

  HadithBloc({required this.getDailyHadith}) : super(const HadithInitial()) {
    on<LoadDailyHadithRequested>(_onLoad);
  }

  Future<void> _onLoad(LoadDailyHadithRequested event, Emitter<HadithState> emit) async {
    emit(const HadithLoading());
    final result = await getDailyHadith(const NoParams());
    result.fold(
      (f) => emit(HadithError(f.message)),
      (hadith) => emit(HadithLoaded(hadith)),
    );
  }
}
