import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/surah_model.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/ayah.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah_detail.dart';

abstract class QuranTextRemoteDataSource {
  Future<List<SurahModel>> fetchSurahList();
  Future<SurahDetail> fetchSurahDetail(int surahNumber);
}

class QuranTextRemoteDataSourceImpl implements QuranTextRemoteDataSource {
  final http.Client client;

  QuranTextRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SurahModel>> fetchSurahList() async {
    try {
      final uri = Uri.parse('${AppConstants.alQuranBaseUrl}/surah');
      final response = await client.get(uri);
      if (response.statusCode != 200) {
        throw ServerException('Failed to fetch surah list: ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>? ?? [];
      return data
          .map((item) => SurahModel.fromApiJson(item as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to connect to Quran API: $e');
    }
  }

  @override
  Future<SurahDetail> fetchSurahDetail(int surahNumber) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.alQuranBaseUrl}/surah/$surahNumber/editions/'
        '${AppConstants.alQuranArabicEdition},${AppConstants.alQuranTranslationEdition}',
      );

      final response = await client.get(uri);
      if (response.statusCode != 200) {
        throw ServerException('Failed to fetch surah detail: ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>? ?? [];
      if (data.isEmpty) {
        throw const ServerException('No surah detail data returned');
      }

      final arabic = data.first as Map<String, dynamic>;
      final translation = data.length > 1 ? data[1] as Map<String, dynamic> : {};

      final surah = Surah(
        number: arabic['number'] as int? ?? surahNumber,
        name: arabic['name']?.toString() ?? '',
        englishName: arabic['englishName']?.toString() ?? '',
        englishNameTranslation: arabic['englishNameTranslation']?.toString() ?? '',
        numberOfAyahs: arabic['numberOfAyahs'] as int? ?? 0,
        revelationType: arabic['revelationType']?.toString() ?? '',
      );

      final arabicAyahs = (arabic['ayahs'] as List<dynamic>? ?? [])
          .map((a) => a as Map<String, dynamic>)
          .toList();
      final translationAyahs = (translation['ayahs'] as List<dynamic>? ?? [])
          .map((a) => a as Map<String, dynamic>)
          .toList();

      final ayahs = <Ayah>[];
      for (var i = 0; i < arabicAyahs.length; i++) {
        final arabicAyah = arabicAyahs[i];
        final translationAyah = i < translationAyahs.length ? translationAyahs[i] : null;

        ayahs.add(
          Ayah(
            numberInSurah: arabicAyah['numberInSurah'] as int? ?? i + 1,
            arabicText: arabicAyah['text']?.toString() ?? '',
            translation: translationAyah?['text']?.toString() ?? '',
          ),
        );
      }

      return SurahDetail(surah: surah, ayahs: ayahs);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to connect to Quran API: $e');
    }
  }
}
