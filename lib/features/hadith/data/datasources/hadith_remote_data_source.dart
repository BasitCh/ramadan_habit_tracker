import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/entities/hadith.dart';

abstract class HadithRemoteDataSource {
  Future<Hadith> fetchDailyHadith();
}

class HadithRemoteDataSourceImpl implements HadithRemoteDataSource {
  final http.Client client;

  HadithRemoteDataSourceImpl({required this.client});

  @override
  Future<Hadith> fetchDailyHadith() async {
    try {
      final uri = Uri.parse(
        '${AppConstants.hadithApiBaseUrl}/hadiths'
        '?apiKey=${AppConstants.hadithApiKey}&limit=1&paginate=0',
      );

      final response = await client.get(uri);
      if (response.statusCode != 200) {
        throw ServerException('Failed to fetch hadith: ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final hadiths = json['hadiths'] as Map<String, dynamic>? ?? {};
      final data = hadiths['data'] as List<dynamic>? ?? [];
      if (data.isEmpty) {
        throw const ServerException('No hadith data returned');
      }

      final item = data.first as Map<String, dynamic>;
      final book = (item['book'] as Map<String, dynamic>?)?['bookName']?.toString() ?? 'Hadith';
      final hadithNumber = item['hadithNumber']?.toString() ?? '';

      return Hadith(
        text: item['hadithEnglish']?.toString() ?? '',
        book: book,
        reference: hadithNumber,
        narrator: item['hadithNarrator']?.toString(),
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to connect to hadith API: $e');
    }
  }
}
