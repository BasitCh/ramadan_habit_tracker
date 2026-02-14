import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/ayah.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah.dart';

class SurahDetail extends Equatable {
  final Surah surah;
  final List<Ayah> ayahs;

  const SurahDetail({
    required this.surah,
    required this.ayahs,
  });

  @override
  List<Object> get props => [surah, ayahs];
}
