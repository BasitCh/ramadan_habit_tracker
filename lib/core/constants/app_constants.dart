class AppConstants {
  AppConstants._();

  // ══════════════════════════════════════════════════════════════════════════
  // Ramadan Dates
  // ══════════════════════════════════════════════════════════════════════════

  // Ramadan 2026 approximate Gregorian dates
  static final DateTime ramadanStart = DateTime(2026, 2, 18);
  static final DateTime ramadanEnd = DateTime(2026, 3, 19);
  static const int totalRamadanDays = 30;

  static int getCurrentRamadanDay() {
    final now = DateTime.now();
    // Reset time components for accurate day calculation
    final nowDate = DateTime(now.year, now.month, now.day);
    final startDate = DateTime(
      ramadanStart.year,
      ramadanStart.month,
      ramadanStart.day,
    );

    final difference = nowDate.difference(startDate).inDays;
    return difference + 1;
  }

  static String getHijriDateString() {
    final day = getCurrentRamadanDay();
    if (day < 1) {
      final daysUntil = day.abs() + 1;
      return '$daysUntil Days to Ramadan';
    }
    if (day > totalRamadanDays) {
      return 'Eid Mubarak';
    }
    return '$day Ramadan 1447';
  }

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

  static const List<String> additionalPrayers = ['Tahajjud', 'Taraweeh'];

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
  static const String aladhanTimingsByLatLngEndpoint = '/timings';

  // Hadith API
  static const String hadithApiBaseUrl = 'https://hadithapi.com/api';
  static const String hadithApiKey =
      r'$2y$10$4tuztKGgTAo4084aCSeV1epjHuaGPbM1UIri0pFB52iIAiVRMbNyS';

  // Al-Quran Cloud API
  static const String alQuranBaseUrl = 'https://api.alquran.cloud/v1';
  static const String alQuranArabicEdition = 'ar.alafasy';
  static const String alQuranTranslationEdition = 'en.asad';

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

  // Ibadah
  static const String ibadahChecklistBox = 'ibadah_checklist_box';

  // Hadith
  static const String hadithBox = 'hadith_box';

  // Quran text
  static const String quranSurahListBox = 'quran_surah_list_box';
  static const String quranSurahDetailBox = 'quran_surah_detail_box';

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
  static const String userLatKey = 'user_lat';
  static const String userLngKey = 'user_lng';
  static const String lastPrayerTimesFetchKey = 'last_prayer_times_fetch';
  static const String lastHijriDateKey = 'last_hijri_date';
  static const String dailyDuaDateKey = 'daily_dua_date';
  static const String dailyDuaIdKey = 'daily_dua_id';

  // ══════════════════════════════════════════════════════════════════════════
  // Cache Duration
  // ══════════════════════════════════════════════════════════════════════════

  static const Duration prayerTimesCacheDuration = Duration(hours: 24);

  // ══════════════════════════════════════════════════════════════════════════
  // Default Values
  // ══════════════════════════════════════════════════════════════════════════

  static const String defaultCity = 'London';
  static const String defaultCountry = 'United Kingdom';
  static const List<Map<String, dynamic>> ramadanChallenges = [
    {
      'day': 1,
      'title': 'Sincere Intention (Niyyah)',
      'description': 'Renew your intention for Allah alone this Ramadan.',
    },
    {
      'day': 2,
      'title': 'Perfect the Fard Prayers',
      'description': 'Pray all 5 on time with focus and khushu.',
    },
    {
      'day': 3,
      'title': 'Small Sadaqah',
      'description': 'Give charity daily—even a smile or helping hand counts.',
    },
    {
      'day': 4,
      'title': 'Durood Shareef x100',
      'description': 'Send blessings on the Prophet ﷺ 100 times.',
    },
    {
      'day': 5,
      'title': 'Kindness to Parents',
      'description': 'Call or make dua for your parents.',
    },
    {
      'day': 6,
      'title': 'Share Iftar',
      'description': 'Feed or invite someone to break fast with you.',
    },
    {
      'day': 7,
      'title': 'Tahajjud (2+ Rakats)',
      'description': 'Wake for night prayer before Suhoor.',
    },
    {
      'day': 8,
      'title': 'Surah Al-Mulk',
      'description': 'Recite Surah Al-Mulk before sleeping.',
    },
    {
      'day': 9,
      'title': 'Istighfar x100',
      'description': 'Seek forgiveness sincerely (Astaghfirullah).',
    },
    {
      'day': 10,
      'title': 'Mosque Care',
      'description': 'Help clean or maintain your local mosque.',
    },
    {
      'day': 11,
      'title': 'Guard Your Tongue',
      'description': 'Avoid backbiting, gossip, or harmful words.',
    },
    {
      'day': 12,
      'title': 'Dhikr of Gratitude',
      'description': 'Recite SubhanAllah wa bihamdihi 100 times.',
    },
    {
      'day': 13,
      'title': 'Visit/Check on Sick',
      'description': 'Call or visit someone unwell.',
    },
    {
      'day': 14,
      'title': 'Sunnah Smile',
      'description': 'Smile at fellow Muslims as a charity.',
    },
    {
      'day': 15,
      'title': 'Mid-Ramadan Reflection',
      'description': 'Review progress and renew goals for the rest.',
    },
    {
      'day': 16,
      'title': 'Surah Al-Kahf',
      'description': 'Recite Surah Al-Kahf (or last 10 verses if Friday).',
    },
    {
      'day': 17,
      'title': 'Kindness to Environment',
      'description': 'Plant, water, or avoid waste as an act of care.',
    },
    {
      'day': 18,
      'title': 'Reconnect Family',
      'description': 'Contact a distant relative or strengthen ties.',
    },
    {
      'day': 19,
      'title': 'La Hawla Wa La Quwwata',
      'description': 'Recite La hawla wala quwwata illa billah 100 times.',
    },
    {
      'day': 20,
      'title': 'Last 10 Nights Prep',
      'description': 'Plan intensified worship for the blessed nights.',
    },
    {
      'day': 21,
      'title': 'Intensify Worship (1st of Last 10)',
      'description': 'Extra Tahajjud, Quran, and dua tonight.',
    },
    {
      'day': 22,
      'title': 'Personal Dua List',
      'description': 'Write and focus on specific duas for yourself.',
    },
    {
      'day': 23,
      'title': 'Donate Unused Items',
      'description': 'Give clothes/food you no longer need.',
    },
    {
      'day': 24,
      'title': 'Surah Al-Ikhlas x3',
      'description': 'Recite Surah Al-Ikhlas 3 times (reward of full Quran).',
    },
    {
      'day': 25,
      'title': 'Forgive Others',
      'description': 'Intentionally forgive anyone who wronged you.',
    },
    {
      'day': 26,
      'title': 'Dua for the Ummah',
      'description': 'Make heartfelt dua for suffering Muslims worldwide.',
    },
    {
      'day': 27,
      'title': 'Laylatul Qadr Vigil',
      'description': 'Worship abundantly—it may be the Night of Power.',
    },
    {
      'day': 28,
      'title': 'Zakat al-Fitr Prep',
      'description': 'Calculate and prepare your Zakat al-Fitr.',
    },
    {
      'day': 29,
      'title': 'Gratitude Journal',
      'description': 'List 10 blessings from this Ramadan.',
    },
    {
      'day': 30,
      'title': 'Eid & Shawwal Plan',
      'description': 'Prepare for Eid and plan to continue good habits.',
    },
  ];

  static const List<String> allIbadahItems = [
    'Pray 5 Fard Prayers on Time',
    'Pray Sunnah Rawatib (12 Rakats Daily)',
    'Pray Duha (2–8 Rakats)',
    'Pray Tahajjud (2+ Rakats)',
    'Pray Witr (Odd Rakats)',
    'Read Quran (at least 1 page or more)',
    'Memorize/Reflect on 1 Ayah',
    'Recite Last 2 Ayat of Surah Al-Baqarah',
    'Recite Surah Al-Mulk before sleep',
    'Recite Surah Al-Kahf (Friday)',
    'Recite Surah Al-Ikhlas 3 times',
    'Durood Shareef x100',
    'Istighfar (Astaghfirullah) x100',
    'SubhanAllah x33, Alhamdulillah x33, Allahu Akbar x34',
    'La Hawla Wala Quwwata Illa Billah x100',
    'Dhikr after Salah (morning/evening Adhkar)',
    'Give Sadaqah (even small amount)',
    'Smile as Charity',
    'Avoid Backbiting/Gossip',
    'Forgive Someone',
    'Call/Help Parents',
    'Contact a Relative',
    'Visit or Call the Sick',
    'Feed/Share with a Fasting Person',
    'Listen to Islamic Lecture/Podcast',
  ];

  static const List<String> dailyIbadahItems = [
    'Pray 5 Fard Prayers on Time',
    'Pray Sunnah Rawatib',
    'Read at least 1 page Quran',
    'Durood Shareef x100',
    'Istighfar x100',
    'Give Sadaqah (small act)',
    'Dhikr: SubhanAllah, Alhamdulillah, Allahu Akbar (33/33/34)',
    'Make fresh Wudu before sleep',
    'Smile at fellow Muslims',
  ];
  // Adhkar categories
  static const String morningAdhkarCategory = 'morning';
  static const String eveningAdhkarCategory = 'evening';
}
