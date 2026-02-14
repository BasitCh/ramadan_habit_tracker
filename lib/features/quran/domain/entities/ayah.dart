import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  final int numberInSurah;
  final String arabicText;
  final String translation;

  const Ayah({
    required this.numberInSurah,
    required this.arabicText,
    required this.translation,
  });

  @override
  List<Object> get props => [numberInSurah, arabicText, translation];
}
