import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/hijri_date_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_time_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_times_result_model.dart';

abstract class PrayerTimesRemoteDataSource {
  Future<PrayerTimesResultModel> fetchPrayerTimes({
    required double lat,
    required double lng,
    required DateTime date,
    required int method,
  });
}

class PrayerTimesRemoteDataSourceImpl implements PrayerTimesRemoteDataSource {
  final http.Client client;

  PrayerTimesRemoteDataSourceImpl({required this.client});

  static const _prayerKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  @override
  Future<PrayerTimesResultModel> fetchPrayerTimes({
    required double lat,
    required double lng,
    required DateTime date,
    required int method,
  }) async {
    try {
      final datePath =
          '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
      final uri = Uri.parse(
        '${AppConstants.aladhanBaseUrl}${AppConstants.aladhanTimingsByLatLngEndpoint}/$datePath'
        '?latitude=$lat&longitude=$lng&method=$method',
      );

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'] as Map<String, dynamic>;
        final timings = data['timings'] as Map<String, dynamic>;
        final hijri = data['date']?['hijri'] as Map<String, dynamic>?;

        final times = _prayerKeys.map((key) {
          final rawTime = timings[key] as String;
          // Aladhan returns "HH:mm (TZ)" - strip the timezone part
          final time = rawTime.split(' ').first;
          return PrayerTimeModel.fromApiJson(key, time);
        }).toList();

        return PrayerTimesResultModel(
          prayerTimes: times,
          hijriDate: hijri == null ? null : HijriDateModel.fromApiJson(hijri),
        );
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
