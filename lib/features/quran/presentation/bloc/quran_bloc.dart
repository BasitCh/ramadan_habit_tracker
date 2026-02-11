import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/update_quran_progress.dart';

part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final GetQuranProgress getQuranProgress;
  final UpdateQuranProgress updateQuranProgress;

  QuranBloc({
    required this.getQuranProgress,
    required this.updateQuranProgress,
  }) : super(const QuranInitial()) {
    on<LoadQuranProgress>(_onLoadProgress);
    on<UpdateJuz>(_onUpdateJuz);
    on<UpdatePagesRead>(_onUpdatePages);
  }

  Future<void> _onLoadProgress(
    LoadQuranProgress event,
    Emitter<QuranState> emit,
  ) async {
    emit(const QuranLoading());
    final result = await getQuranProgress(event.date);
    result.fold(
      (failure) => emit(QuranError(failure.message)),
      (progress) => emit(QuranLoaded(progress)),
    );
  }

  Future<void> _onUpdateJuz(UpdateJuz event, Emitter<QuranState> emit) async {
    final currentState = state;
    if (currentState is QuranLoaded) {
      final updated = currentState.progress.copyWith(currentJuz: event.juz);
      final result = await updateQuranProgress(updated);
      result.fold(
        (failure) => emit(QuranError(failure.message)),
        (progress) => emit(QuranLoaded(progress)),
      );
    }
  }

  Future<void> _onUpdatePages(
    UpdatePagesRead event,
    Emitter<QuranState> emit,
  ) async {
    final currentState = state;
    if (currentState is QuranLoaded) {
      final updated = currentState.progress.copyWith(pagesRead: event.pages);
      final result = await updateQuranProgress(updated);
      result.fold(
        (failure) => emit(QuranError(failure.message)),
        (progress) => emit(QuranLoaded(progress)),
      );
    }
  }
}
