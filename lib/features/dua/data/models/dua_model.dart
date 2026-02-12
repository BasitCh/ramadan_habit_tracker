import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/entities/dua.dart';

part 'dua_model.g.dart';

@HiveType(typeId: 14)
class DuaModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String arabic;

  @HiveField(2)
  final String transliteration;

  @HiveField(3)
  final String translation;

  @HiveField(4)
  final String reference;

  @HiveField(5)
  final bool isBookmarked;

  @HiveField(6)
  final bool isRecited;

  DuaModel({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.reference,
    this.isBookmarked = false,
    this.isRecited = false,
  });

  Dua toEntity() => Dua(
        id: id,
        arabic: arabic,
        transliteration: transliteration,
        translation: translation,
        reference: reference,
        isBookmarked: isBookmarked,
        isRecited: isRecited,
      );

  factory DuaModel.fromJson(Map<String, dynamic> json) => DuaModel(
        id: json['id'] as String,
        arabic: json['arabic'] as String,
        transliteration: json['transliteration'] as String,
        translation: json['translation'] as String,
        reference: json['reference'] as String,
      );
}
