import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';

class SurahDetailPage extends StatefulWidget {
  final int surahNumber;

  const SurahDetailPage({super.key, required this.surahNumber});

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late AudioPlayer _audioPlayer;
  late ScrollController _scrollController;
  SharedPreferences? _prefs;

  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasScrolledToLastSeen = false;

  int? _lastSeenAyahNumber;
  final _lastSeenKey = GlobalKey();

  String get _prefsAyahKey => 'surah_${widget.surahNumber}_last_ayah';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _scrollController = ScrollController();
    context.read<QuranBloc>().add(LoadSurahDetailRequested(widget.surahNumber));
    context.read<QuranBloc>().add(
      SetLastReadSurahRequested(widget.surahNumber),
    );
    _initAudioSession();
    _loadPrefs();

    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _isLoading =
              state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.stop();
        _audioPlayer.seek(Duration.zero);
      }
    });
  }

  Future<void> _loadPrefs() async {
    _prefs = GetIt.instance<SharedPreferences>();
    final saved = _prefs?.getInt(_prefsAyahKey);
    if (saved != null && mounted) {
      setState(() => _lastSeenAyahNumber = saved);
    }
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  void _scrollToLastSeenIfNeeded() {
    if (_hasScrolledToLastSeen || _lastSeenAyahNumber == null) return;
    _hasScrolledToLastSeen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _lastSeenKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          alignment: 0.1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _saveLastSeenAyah(int ayahNumber) {
    setState(() => _lastSeenAyahNumber = ayahNumber);
    _prefs?.setInt(_prefsAyahKey, ayahNumber);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.bookmark, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text('Ayah $ayahNumber saved as last seen'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_audioPlayer.duration == null) {
          setState(() => _isLoading = true);
          final surahId = widget.surahNumber.toString().padLeft(3, '0');
          final url = 'https://server8.mp3quran.net/afs/$surahId.mp3';
          await _audioPlayer.setUrl(url);
        }
        await _audioPlayer.play();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error playing audio: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: _buildAudioBar(),
      body: SafeArea(
        child: BlocBuilder<QuranBloc, QuranState>(
          builder: (context, state) {
            if (state is QuranLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is QuranError) {
              return Center(child: Text(state.message));
            }
            if (state is QuranLoaded && state.surahDetail != null) {
              _scrollToLastSeenIfNeeded();
              final detail = state.surahDetail!;
              return ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 16),
                  // Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.surah.englishName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${detail.surah.englishNameTranslation} • ${detail.surah.numberOfAyahs} ayahs',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.read<QuranBloc>().add(
                          BookmarkSurahToggled(widget.surahNumber),
                        ),
                        icon: Icon(
                          state.bookmarkedSurahs.contains(widget.surahNumber)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: AppColors.primary,
                        ),
                        tooltip:
                            state.bookmarkedSurahs.contains(widget.surahNumber)
                            ? 'Remove bookmark'
                            : 'Bookmark surah',
                      ),
                      Text(
                        detail.surah.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Last seen banner
                  if (_lastSeenAyahNumber != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bookmark,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Resuming from Ayah $_lastSeenAyahNumber',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _lastSeenAyahNumber = null;
                                _hasScrolledToLastSeen = false;
                              });
                              _prefs?.remove(_prefsAyahKey);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Ayah list
                  ...detail.ayahs.map((ayah) {
                    final isLastSeen =
                        ayah.numberInSurah == _lastSeenAyahNumber;
                    return Padding(
                      key: isLastSeen ? _lastSeenKey : null,
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isLastSeen
                              ? AppColors.secondary.withValues(alpha: 0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: isLastSeen
                              ? Border.all(
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.3,
                                  ),
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isLastSeen
                                        ? AppColors.secondary.withValues(
                                            alpha: 0.15,
                                          )
                                        : AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ayah.numberInSurah.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isLastSeen
                                            ? AppColors.secondary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    ayah.arabicText,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Save as last seen button
                                Tooltip(
                                  message: isLastSeen
                                      ? 'Last seen'
                                      : 'Save as last seen',
                                  child: IconButton(
                                    icon: Icon(
                                      isLastSeen
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      size: 20,
                                    ),

                                    color: isLastSeen
                                        ? AppColors.secondary
                                        : AppColors.textSecondary.withValues(
                                            alpha: 0.5,
                                          ),
                                    onPressed: () {
                                      _saveLastSeenAyah(ayah.numberInSurah);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              ayah.translation,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 100),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAudioBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: _isPlaying || _isLoading
          ? _buildExpandedPlayer()
          : _buildCollapsedPlayer(),
    );
  }

  Widget _buildCollapsedPlayer() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.music_note,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mishary Rashid Alafasy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Tap play to listen',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _toggleAudio,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedPlayer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.music_note,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Mishary Rashid Alafasy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Now Playing',
                    style: TextStyle(fontSize: 11, color: AppColors.secondary),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _toggleAudio,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StreamBuilder<Duration?>(
          stream: _audioPlayer.durationStream,
          builder: (context, durationSnapshot) {
            final total = durationSnapshot.data ?? Duration.zero;
            return StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;
                final progress = total.inMilliseconds > 0
                    ? (position.inMilliseconds / total.inMilliseconds).clamp(
                        0.0,
                        1.0,
                      )
                    : 0.0;
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                      ),
                      child: Slider(
                        value: progress,
                        onChanged: (value) {
                          if (total.inMilliseconds > 0) {
                            _audioPlayer.seek(
                              Duration(
                                milliseconds: (value * total.inMilliseconds)
                                    .round(),
                              ),
                            );
                          }
                        },
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.primaryLight,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            _formatDuration(total),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
