class AppConstants {
  AppConstants._();

  // Ramadan 2026 approximate Gregorian dates
  static final DateTime ramadanStart = DateTime(2026, 2, 18);
  static final DateTime ramadanEnd = DateTime(2026, 3, 19);
  static const int totalRamadanDays = 30;

  static const List<String> prayerNames = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  static const List<String> additionalPrayers = [
    'Tahajjud',
    'Taraweeh',
  ];

  static const int totalJuz = 30;
  static const int totalPages = 604;
  static const int pagesPerJuz = 20;

  // Hive box names
  static const String habitsBox = 'habits';
  static const String habitLogsBox = 'habit_logs';
  static const String prayerLogsBox = 'prayer_logs';
  static const String quranProgressBox = 'quran_progress';
  static const String fastingLogsBox = 'fasting_logs';
  static const String dhikrBox = 'dhikr';

  // Default dhikr items
  static const List<Map<String, dynamic>> defaultDhikr = [
    {'name': 'SubhanAllah', 'target': 33},
    {'name': 'Alhamdulillah', 'target': 33},
    {'name': 'Allahu Akbar', 'target': 34},
    {'name': 'La ilaha illallah', 'target': 100},
    {'name': 'Astaghfirullah', 'target': 100},
  ];
}
