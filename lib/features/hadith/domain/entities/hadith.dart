import 'package:equatable/equatable.dart';

class Hadith extends Equatable {
  final String text;
  final String book;
  final String reference;
  final String? narrator;

  const Hadith({
    required this.text,
    required this.book,
    required this.reference,
    this.narrator,
  });

  @override
  List<Object?> get props => [text, book, reference, narrator];
}
