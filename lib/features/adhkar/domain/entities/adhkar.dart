import 'package:equatable/equatable.dart';

class Adhkar extends Equatable {
  final String id;
  final String arabic;
  final String transliteration;
  final String translation;
  final int repetitions;
  final String reference;
  final String category; // 'morning' or 'evening'
  final int currentCount;

  const Adhkar({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.repetitions,
    required this.reference,
    required this.category,
    this.currentCount = 0,
  });

  bool get isCompleted => currentCount >= repetitions;
  double get progress => repetitions > 0 ? (currentCount / repetitions).clamp(0.0, 1.0) : 0.0;

  Adhkar copyWith({int? currentCount}) {
    return Adhkar(
      id: id,
      arabic: arabic,
      transliteration: transliteration,
      translation: translation,
      repetitions: repetitions,
      reference: reference,
      category: category,
      currentCount: currentCount ?? this.currentCount,
    );
  }

  @override
  List<Object?> get props => [id, arabic, transliteration, translation, repetitions, reference, category, currentCount];
}
