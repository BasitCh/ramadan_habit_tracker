import 'package:flutter/material.dart';

class GuideSection {
  final String title;
  final String body;

  const GuideSection({required this.title, required this.body});
}

class GuideEntry {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;
  final List<GuideSection> sections;

  const GuideEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.sections,
  });
}

class GuideContent {
  static const List<GuideEntry> entries = [
    GuideEntry(
      id: 'last-10-days',
      title: 'Last 10 Days of Ramadan',
      subtitle: 'Maximizing the blessed nights for spiritual growth',
      tag: 'RAMADAN EXCLUSIVE',
      icon: Icons.bedtime,
      sections: [
        GuideSection(
          title: 'Renewing Intentions (Niyyah)',
          body:
              'As the last ten days approach, refresh your intention. Remind yourself that you are seeking the pleasure of Allah and the reward of Laylatul Qadr. Make a specific plan for these nights, balancing worship, rest, & responsibilities.',
        ),
        GuideSection(
          title: 'The Night of Power (Laylatul Qadr)',
          body:
              'Worship on this night is better than a thousand months (83 years). Focus on Salah, Quran recitation, and sincere Dua. The Prophet (PBUH) taught us to say: "Allahumma innaka \'afuwwun tuhibbul \'afwa fa\'fu \'annee" (O Allah, You are Forgiving and love forgiveness, so forgive me).',
        ),
        GuideSection(
          title: 'Seclusion (Itikaf)',
          body:
              'If possible, perform Itikaf (seclusion) in the Masjid. If not, create a "spiritual sanctuary" in your home where you can disconnect from the world and connect with Allah for a few hours each night.',
        ),
        GuideSection(
          title: 'Charity Strategy',
          body:
              'Give a small amount of charity every night of the last ten days. If it falls on Laylatul Qadr, it will be as if you gave charity every day for 83 years.',
        ),
      ],
    ),
    GuideEntry(
      id: 'tahajjud',
      title: 'Tahajjud Guide',
      subtitle: 'The best prayer after the obligatory ones',
      tag: 'NIGHT PRAYER',
      icon: Icons.nights_stay,
      sections: [
        GuideSection(
          title: 'Virtues',
          body:
              'The Prophet (PBUH) said: "The best prayer after the obligatory prayers is the night prayer." It is a time when the Divine descends to the lowest heaven, asking: "Who is asking Me, so that I may give him?"',
        ),
        GuideSection(
          title: 'How to Perform',
          body:
              '1. Sleep early with Wudu.\n2. Set multiple alarms.\n3. Drink water upon waking.\n4. Start with 2 light rakats.\n5. Pour your heart out in Sujood. You can pray 2, 4, 8 or more rakats, followed by Witr.',
        ),
        GuideSection(
          title: 'Consistency Key',
          body:
              'It is better to pray 2 rakats consistently than 8 rakats once a week. Start small. If you cannot wake up, pray a few rakats after Isha (before Witr) as Qiyam-ul-Layl.',
        ),
      ],
    ),
    GuideEntry(
      id: 'zakat',
      title: 'Zakat Calculator',
      subtitle: 'Purify your wealth',
      tag: 'FINANCE',
      icon: Icons.calculate,
      sections: [
        GuideSection(
          title: 'Who Must Pay?',
          body:
              'Zakat is obligatory on every sane, adult Muslim whose wealth exceeds the Nisab (minimum threshold - approx value of 87.48g gold) and has been held for one lunar year.',
        ),
        GuideSection(
          title: 'What is Vatable?',
          body:
              '- Cash (in hand/bank)\n- Gold & Silver (jewelry/bars)\n- Business Inventory (current value)\n- Investments/Shares\n- Money owed to you (expected to be returned)',
        ),
        GuideSection(
          title: 'Calculation',
          body:
              'Subtract immediate debts due. Calculate 2.5% of the total net assets. For example, if your net assets are \$10,000, your Zakat is \$250. Give this to the poor, needy, or other eligible categories mentioned in the Quran.',
        ),
      ],
    ),
    GuideEntry(
      id: 'sunnah-library',
      title: 'Sunnah Library',
      subtitle: 'Reviving the Prophet\'s (PBUH) habits',
      tag: 'SUNNAH',
      icon: Icons.menu_book,
      sections: [
        GuideSection(
          title: 'Morning Sunnahs',
          body:
              '- Wake up and rub face with hands\n- Recite waking dua\n- Use Miswak/Brush teeth\n- Perform Wudu\n- Pray Fajr Sunnah at home',
        ),
        GuideSection(
          title: 'Eating Etiquette',
          body:
              '- Wash hands before eating\n- Say Bismillah\n- Eat with right hand\n- Eat from what is nearest to you\n- Praise Allah after eating',
        ),
        GuideSection(
          title: 'Sleep Sunnahs',
          body:
              '- Perform Wudu before sleep\n- Dust the bed\n- Recite 3 Quls and blow on hands and wipe over body\n- Sleep on right side',
        ),
      ],
    ),
    GuideEntry(
      id: 'daily-dhikr',
      title: 'Daily Dhikr',
      subtitle: 'Fortress of the Muslim',
      tag: 'ADHKAR',
      icon: Icons.star,
      sections: [
        GuideSection(
          title: 'Morning (After Fajr)',
          body:
              '- Ayat al-Kursi\n- 3 Quls (3 times each)\n- "Allahumma bika asbahna..."\n- "SubhanAllahi wa bihamdihi" (100 times)',
        ),
        GuideSection(
          title: 'Evening (After Asr/Maghrib)',
          body:
              '- Ayat al-Kursi\n- 3 Quls (3 times each)\n- "Amsayna wa amsal mulku lillah..."\n- "Astaghfirullah" (100 times)',
        ),
        GuideSection(
          title: 'General Dhikr',
          body:
              'Keep your tongue moist with "SubhanAllah, Alhamdulillah, La ilaha illallah, Allahu Akbar" throughout the day.',
        ),
      ],
    ),
  ];

  static GuideEntry? byId(String id) {
    try {
      return entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
