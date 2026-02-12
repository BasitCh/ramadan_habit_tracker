class AppConstants {
  AppConstants._();

  // ══════════════════════════════════════════════════════════════════════════
  // Ramadan Dates
  // ══════════════════════════════════════════════════════════════════════════

  // Ramadan 2026 approximate Gregorian dates
  static final DateTime ramadanStart = DateTime(2026, 2, 18);
  static final DateTime ramadanEnd = DateTime(2026, 3, 19);
  static const int totalRamadanDays = 30;

  // ══════════════════════════════════════════════════════════════════════════
  // Prayer Names
  // ══════════════════════════════════════════════════════════════════════════

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

  // ══════════════════════════════════════════════════════════════════════════
  // Quran Constants
  // ══════════════════════════════════════════════════════════════════════════

  static const int totalJuz = 30;
  static const int totalPages = 604;
  static const int pagesPerJuz = 20;

  // ══════════════════════════════════════════════════════════════════════════
  // API URLs
  // ══════════════════════════════════════════════════════════════════════════

  // Aladhan Prayer Times API
  static const String aladhanBaseUrl = 'https://api.aladhan.com/v1';
  static const String aladhanTimingsByCityEndpoint = '/timingsByCity';
  static const String aladhanTimingsByAddressEndpoint = '/timingsByAddress';

  // Default calculation method (2 = ISNA - Islamic Society of North America)
  static const int defaultCalculationMethod = 2;

  // ══════════════════════════════════════════════════════════════════════════
  // Hive Box Names
  // ══════════════════════════════════════════════════════════════════════════

  // Auth
  static const String userBox = 'user_box';

  // Prayer
  static const String prayerTimesBox = 'prayer_times_box';
  static const String prayerLogsBox = 'prayer_logs_box';
  static const String prayerStreakBox = 'prayer_streak_box';

  // Quran
  static const String quranProgressBox = 'quran_progress_box';

  // Dua
  static const String duasBox = 'duas_box';
  static const String duaBookmarksBox = 'dua_bookmarks_box';

  // Adhkar
  static const String adhkarBox = 'adhkar_box';
  static const String adhkarProgressBox = 'adhkar_progress_box';

  // ══════════════════════════════════════════════════════════════════════════
  // Asset Paths
  // ══════════════════════════════════════════════════════════════════════════

  static const String duasJsonPath = 'assets/data/duas.json';
  static const String morningAdhkarJsonPath = 'assets/data/morning_adhkar.json';
  static const String eveningAdhkarJsonPath = 'assets/data/evening_adhkar.json';

  // ══════════════════════════════════════════════════════════════════════════
  // Shared Preferences Keys
  // ══════════════════════════════════════════════════════════════════════════

  static const String isAuthenticatedKey = 'is_authenticated';
  static const String userPhoneKey = 'user_phone';
  static const String userCityKey = 'user_city';
  static const String userCountryKey = 'user_country';
  static const String lastPrayerTimesFetchKey = 'last_prayer_times_fetch';

  // ══════════════════════════════════════════════════════════════════════════
  // Cache Duration
  // ══════════════════════════════════════════════════════════════════════════

  static const Duration prayerTimesCacheDuration = Duration(hours: 24);

  // ══════════════════════════════════════════════════════════════════════════
  // Default Values
  // ══════════════════════════════════════════════════════════════════════════

  static const String defaultCity = 'London';
  static const String defaultCountry = 'United Kingdom';

  // Adhkar categories
  static const String morningAdhkarCategory = 'morning';
  static const String eveningAdhkarCategory = 'evening';
}
