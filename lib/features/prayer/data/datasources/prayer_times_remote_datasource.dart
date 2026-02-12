import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_time_model.dart';

abstract class PrayerTimesRemoteDataSource {
  Future<List<PrayerTimeModel>> fetchPrayerTimes({
    required String city,
    required String country,
    required int method,
  });
}

class PrayerTimesRemoteDataSourceImpl implements PrayerTimesRemoteDataSource {
  final http.Client client;

  PrayerTimesRemoteDataSourceImpl({required this.client});

  static const _prayerKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  @override
  Future<List<PrayerTimeModel>> fetchPrayerTimes({
    required String city,
    required String country,
    required int method,
  }) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.aladhanBaseUrl}${AppConstants.aladhanTimingsByCityEndpoint}'
        '?city=$city&country=$country&method=$method',
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'] as Map<String, dynamic>;
        final timings = data['timings'] as Map<String, dynamic>;

        return _prayerKeys.map((key) {
          final rawTime = timings[key] as String;
          // Aladhan returns "HH:mm (TZ)" - strip the timezone part
          final time = rawTime.split(' ').first;
          return PrayerTimeModel.fromApiJson(key, time);
        }).toList();
      } else {
        throw ServerException('Failed to fetch prayer times: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to connect to prayer times API: $e');
    }
  }
}
