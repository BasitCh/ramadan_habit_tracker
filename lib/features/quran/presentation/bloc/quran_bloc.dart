import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah_detail.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_surah_detail.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_surah_list.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/reset_quran_progress.dart';
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

class LoadQuranOverviewRequested extends QuranEvent {
  const LoadQuranOverviewRequested();
}

class LoadSurahDetailRequested extends QuranEvent {
  final int surahNumber;
  const LoadSurahDetailRequested(this.surahNumber);
  @override
  List<Object> get props => [surahNumber];
}

class UpdatePagesReadRequested extends QuranEvent {
  final int pages;
  const UpdatePagesReadRequested(this.pages);
  @override
  List<Object> get props => [pages];
}

class ResetQuranProgressRequested extends QuranEvent {
  const ResetQuranProgressRequested();
}

// ── States ──────────────────────────────────────────────────────────────────

sealed class QuranState extends Equatable {
  final QuranProgress? progress;
  final List<Surah>? surahList;
  final SurahDetail? surahDetail;

  const QuranState({this.progress, this.surahList, this.surahDetail});
  @override
  List<Object?> get props => [];
}

class QuranInitial extends QuranState {
  const QuranInitial();
}

class QuranLoading extends QuranState {
  const QuranLoading({super.progress, super.surahList, super.surahDetail});
}

class QuranLoaded extends QuranState {
  const QuranLoaded({
    required super.progress,
    required super.surahList,
    super.surahDetail,
  });
  @override
  List<Object?> get props => [progress, surahList, surahDetail];
}

class QuranError extends QuranState {
  final String message;
  const QuranError(
    this.message, {
    super.progress,
    super.surahList,
    super.surahDetail,
  });
  @override
  List<Object?> get props => [message, progress, surahList, surahDetail];
}

// ── Bloc ────────────────────────────────────────────────────────────────────

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final GetQuranProgress getQuranProgress;
  final UpdatePagesRead updatePagesRead;
  final GetSurahList getSurahList;
  final GetSurahDetail getSurahDetail;
  final ResetQuranProgress resetQuranProgress;

  QuranProgress? _progressCache;
  List<Surah>? _surahListCache;
  SurahDetail? _surahDetailCache;

  QuranBloc({
    required this.getQuranProgress,
    required this.updatePagesRead,
    required this.getSurahList,
    required this.getSurahDetail,
    required this.resetQuranProgress,
  }) : super(const QuranInitial()) {
    on<LoadQuranProgressRequested>(_onLoadProgress);
    on<LoadQuranOverviewRequested>(_onLoadOverview);
    on<LoadSurahDetailRequested>(_onLoadDetail);
    on<UpdatePagesReadRequested>(_onUpdate);
    on<ResetQuranProgressRequested>(_onReset);
  }

  Future<void> _onLoadProgress(
    LoadQuranProgressRequested event,
    Emitter<QuranState> emit,
  ) async {
    emit(
      QuranLoading(
        progress: _progressCache,
        surahList: _surahListCache,
        surahDetail: _surahDetailCache,
      ),
    );
    final result = await getQuranProgress(const NoParams());
    result.fold(
      (f) => emit(
        QuranError(
          f.message,
          progress: _progressCache,
          surahList: _surahListCache,
          surahDetail: _surahDetailCache,
        ),
      ),
      (p) {
        _progressCache = p;
        if (_surahListCache != null) {
          emit(
            QuranLoaded(
              progress: p,
              surahList: _surahListCache!,
              surahDetail: _surahDetailCache,
            ),
          );
        }
      },
    );
  }

  Future<void> _onLoadOverview(
    LoadQuranOverviewRequested event,
    Emitter<QuranState> emit,
  ) async {
    emit(
      QuranLoading(
        progress: _progressCache,
        surahList: _surahListCache,
        surahDetail: _surahDetailCache,
      ),
    );

    final progressResult = await getQuranProgress(const NoParams());
    final listResult = await getSurahList(const NoParams());

    progressResult.fold(
      (f) => emit(
        QuranError(
          f.message,
          progress: _progressCache,
          surahList: _surahListCache,
          surahDetail: _surahDetailCache,
        ),
      ),
      (p) => _progressCache = p,
    );

    listResult.fold(
      (f) => emit(
        QuranError(
          f.message,
          progress: _progressCache,
          surahList: _surahListCache,
          surahDetail: _surahDetailCache,
        ),
      ),
      (list) => _surahListCache = list,
    );

    if (_progressCache != null && _surahListCache != null) {
      emit(
        QuranLoaded(
          progress: _progressCache!,
          surahList: _surahListCache!,
          surahDetail: _surahDetailCache,
        ),
      );
    }
  }

  Future<void> _onLoadDetail(
    LoadSurahDetailRequested event,
    Emitter<QuranState> emit,
  ) async {
    emit(
      QuranLoading(
        progress: _progressCache,
        surahList: _surahListCache,
        surahDetail: _surahDetailCache,
      ),
    );

    final detailResult = await getSurahDetail(
      GetSurahDetailParams(surahNumber: event.surahNumber),
    );

    // Ensure caches are populated
    if (_progressCache == null) {
      final res = await getQuranProgress(const NoParams());
      res.fold((_) {}, (r) => _progressCache = r);
    }

    if (_surahListCache == null) {
      final res = await getSurahList(const NoParams());
      res.fold((_) {}, (r) => _surahListCache = r);
    }

    detailResult.fold(
      (f) => emit(
        QuranError(
          f.message,
          progress: _progressCache,
          surahList: _surahListCache,
          surahDetail: _surahDetailCache,
        ),
      ),
      (detail) {
        _surahDetailCache = detail;
        if (_progressCache != null && _surahListCache != null) {
          emit(
            QuranLoaded(
              progress: _progressCache!,
              surahList: _surahListCache!,
              surahDetail: detail,
            ),
          );
        } else {
          emit(
            QuranError(
              'Failed to load required Quran data',
              progress: _progressCache,
              surahList: _surahListCache,
              surahDetail: detail,
            ),
          );
        }
      },
    );
  }

  Future<void> _onUpdate(
    UpdatePagesReadRequested event,
    Emitter<QuranState> emit,
  ) async {
    final result = await updatePagesRead(UpdatePagesParams(pages: event.pages));
    result.fold(
      (f) => emit(
        QuranError(
          f.message,
          progress: _progressCache,
          surahList: _surahListCache,
          surahDetail: _surahDetailCache,
        ),
      ),
      (p) {
        _progressCache = p;
        if (_surahListCache != null) {
          emit(
            QuranLoaded(
              progress: p,
              surahList: _surahListCache!,
              surahDetail: _surahDetailCache,
            ),
          );
        }
      },
    );
  }

  Future<void> _onReset(
    ResetQuranProgressRequested event,
    Emitter<QuranState> emit,
  ) async {
    final result = await resetQuranProgress(const NoParams());
    result.fold(
      (f) => emit(
        QuranError(
          f.message,
          progress: _progressCache,
          surahList: _surahListCache,
          surahDetail: _surahDetailCache,
        ),
      ),
      (p) {
        _progressCache = p;
        if (_surahListCache != null) {
          emit(
            QuranLoaded(
              progress: p,
              surahList: _surahListCache!,
              surahDetail: _surahDetailCache,
            ),
          );
        }
      },
    );
  }
}
