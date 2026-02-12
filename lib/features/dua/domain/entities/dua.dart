import 'package:equatable/equatable.dart';

class Dua extends Equatable {
  final String id;
  final String arabic;
  final String transliteration;
  final String translation;
  final String reference;
  final bool isBookmarked;
  final bool isRecited;

  const Dua({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.reference,
    this.isBookmarked = false,
    this.isRecited = false,
  });

  Dua copyWith({bool? isBookmarked, bool? isRecited}) {
    return Dua(
      id: id,
      arabic: arabic,
      transliteration: transliteration,
      translation: translation,
      reference: reference,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRecited: isRecited ?? this.isRecited,
    );
  }

  @override
  List<Object?> get props => [id, arabic, transliteration, translation, reference, isBookmarked, isRecited];
}
