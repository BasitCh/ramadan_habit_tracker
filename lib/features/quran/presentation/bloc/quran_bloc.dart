import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class BookmarkSurahToggled extends QuranEvent {
  final int surahNumber;
  const BookmarkSurahToggled(this.surahNumber);
  @override
  List<Object> get props => [surahNumber];
}

class SetLastReadSurahRequested extends QuranEvent {
  final int surahNumber;
  const SetLastReadSurahRequested(this.surahNumber);
  @override
  List<Object> get props => [surahNumber];
}

// ── States ──────────────────────────────────────────────────────────────────

sealed class QuranState extends Equatable {
  final QuranProgress? progress;
  final List<Surah>? surahList;
  final SurahDetail? surahDetail;
  final List<int> bookmarkedSurahs;
  final int? lastReadSurahNumber;

  const QuranState({
    this.progress,
    this.surahList,
    this.surahDetail,
    this.bookmarkedSurahs = const [],
    this.lastReadSurahNumber,
  });
  @override
  List<Object?> get props => [];
}

class QuranInitial extends QuranState {
  const QuranInitial();
}

class QuranLoading extends QuranState {
  const QuranLoading({
    super.progress,
    super.surahList,
    super.surahDetail,
    super.bookmarkedSurahs,
    super.lastReadSurahNumber,
  });
}

class QuranLoaded extends QuranState {
  const QuranLoaded({
    required super.progress,
    required super.surahList,
    super.surahDetail,
    super.bookmarkedSurahs,
    super.lastReadSurahNumber,
  });
  @override
  List<Object?> get props => [
    progress,
    surahList,
    surahDetail,
    bookmarkedSurahs,
    lastReadSurahNumber,
  ];
}

class QuranError extends QuranState {
  final String message;
  const QuranError(
    this.message, {
    super.progress,
    super.surahList,
    super.surahDetail,
    super.bookmarkedSurahs,
    super.lastReadSurahNumber,
  });
  @override
  List<Object?> get props => [
    message,
    progress,
    surahList,
    surahDetail,
    bookmarkedSurahs,
    lastReadSurahNumber,
  ];
}

// ── Bloc ────────────────────────────────────────────────────────────────────

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final GetQuranProgress getQuranProgress;
  final UpdatePagesRead updatePagesRead;
  final GetSurahList getSurahList;
  final GetSurahDetail getSurahDetail;
  final ResetQuranProgress resetQuranProgress;
  final SharedPreferences sharedPreferences;

  QuranProgress? _progressCache;
  List<Surah>? _surahListCache;
  SurahDetail? _surahDetailCache;
  List<int> _bookmarksCache = [];
  int? _lastReadSurahNumber;

  static const _bookmarksKey = 'quran_bookmarks';
  static const _lastReadKey = 'quran_last_read_surah';

  QuranBloc({
    required this.getQuranProgress,
    required this.updatePagesRead,
    required this.getSurahList,
    required this.getSurahDetail,
    required this.resetQuranProgress,
    required this.sharedPreferences,
  }) : super(const QuranInitial()) {
    on<LoadQuranProgressRequested>(_onLoadProgress);
    on<LoadQuranOverviewRequested>(_onLoadOverview);
    on<LoadSurahDetailRequested>(_onLoadDetail);
    on<UpdatePagesReadRequested>(_onUpdate);
    on<ResetQuranProgressRequested>(_onReset);
    on<BookmarkSurahToggled>(_onBookmarkToggle);
    on<SetLastReadSurahRequested>(_onSetLastRead);
    _loadMeta();
  }

  void _loadMeta() {
    final bookmarkStrings = sharedPreferences.getStringList(_bookmarksKey) ?? [];
    _bookmarksCache = bookmarkStrings
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList();
    _lastReadSurahNumber = sharedPreferences.getInt(_lastReadKey);
  }

  QuranLoaded _makeLoaded({SurahDetail? detail}) => QuranLoaded(
    progress: _progressCache!,
    surahList: _surahListCache!,
    surahDetail: detail ?? _surahDetailCache,
    bookmarkedSurahs: _bookmarksCache,
    lastReadSurahNumber: _lastReadSurahNumber,
  );

  QuranError _makeError(String message, {SurahDetail? detail}) => QuranError(
    message,
    progress: _progressCache,
    surahList: _surahListCache,
    surahDetail: detail ?? _surahDetailCache,
    bookmarkedSurahs: _bookmarksCache,
    lastReadSurahNumber: _lastReadSurahNumber,
  );

  Future<void> _onLoadProgress(
    LoadQuranProgressRequested event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading(
      progress: _progressCache,
      surahList: _surahListCache,
      surahDetail: _surahDetailCache,
      bookmarkedSurahs: _bookmarksCache,
      lastReadSurahNumber: _lastReadSurahNumber,
    ));
    final result = await getQuranProgress(const NoParams());
    result.fold(
      (f) => emit(_makeError(f.message)),
      (p) {
        _progressCache = p;
        if (_surahListCache != null) emit(_makeLoaded());
      },
    );
  }

  Future<void> _onLoadOverview(
    LoadQuranOverviewRequested event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading(
      progress: _progressCache,
      surahList: _surahListCache,
      surahDetail: _surahDetailCache,
      bookmarkedSurahs: _bookmarksCache,
      lastReadSurahNumber: _lastReadSurahNumber,
    ));

    final progressResult = await getQuranProgress(const NoParams());
    final listResult = await getSurahList(const NoParams());

    progressResult.fold(
      (f) => emit(_makeError(f.message)),
      (p) => _progressCache = p,
    );

    listResult.fold(
      (f) => emit(_makeError(f.message)),
      (list) => _surahListCache = list,
    );

    if (_progressCache != null && _surahListCache != null) {
      emit(_makeLoaded());
    }
  }

  Future<void> _onLoadDetail(
    LoadSurahDetailRequested event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading(
      progress: _progressCache,
      surahList: _surahListCache,
      surahDetail: _surahDetailCache,
      bookmarkedSurahs: _bookmarksCache,
      lastReadSurahNumber: _lastReadSurahNumber,
    ));

    final detailResult = await getSurahDetail(
      GetSurahDetailParams(surahNumber: event.surahNumber),
    );

    if (_progressCache == null) {
      final res = await getQuranProgress(const NoParams());
      res.fold((_) {}, (r) => _progressCache = r);
    }

    if (_surahListCache == null) {
      final res = await getSurahList(const NoParams());
      res.fold((_) {}, (r) => _surahListCache = r);
    }

    detailResult.fold(
      (f) => emit(_makeError(f.message)),
      (detail) {
        _surahDetailCache = detail;
        if (_progressCache != null && _surahListCache != null) {
          emit(_makeLoaded(detail: detail));
        } else {
          emit(_makeError('Failed to load required Quran data', detail: detail));
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
      (f) => emit(_makeError(f.message)),
      (p) {
        _progressCache = p;
        if (_surahListCache != null) emit(_makeLoaded());
      },
    );
  }

  Future<void> _onReset(
    ResetQuranProgressRequested event,
    Emitter<QuranState> emit,
  ) async {
    final result = await resetQuranProgress(const NoParams());
    result.fold(
      (f) => emit(_makeError(f.message)),
      (p) {
        _progressCache = p;
        if (_surahListCache != null) emit(_makeLoaded());
      },
    );
  }

  Future<void> _onBookmarkToggle(
    BookmarkSurahToggled event,
    Emitter<QuranState> emit,
  ) async {
    if (_bookmarksCache.contains(event.surahNumber)) {
      _bookmarksCache = List.from(_bookmarksCache)..remove(event.surahNumber);
    } else {
      _bookmarksCache = List.from(_bookmarksCache)..add(event.surahNumber);
    }
    await sharedPreferences.setStringList(
      _bookmarksKey,
      _bookmarksCache.map((n) => n.toString()).toList(),
    );
    if (_progressCache != null && _surahListCache != null) {
      emit(_makeLoaded());
    }
  }

  Future<void> _onSetLastRead(
    SetLastReadSurahRequested event,
    Emitter<QuranState> emit,
  ) async {
    _lastReadSurahNumber = event.surahNumber;
    await sharedPreferences.setInt(_lastReadKey, event.surahNumber);
    if (_progressCache != null && _surahListCache != null) {
      emit(_makeLoaded());
    }
  }
}
