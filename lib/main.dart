import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();
  runApp(const RifqApp());
}

// =====================================================
// STORAGE
// =====================================================

class AppStorage {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static int getCount(String id) => prefs.getInt('count_$id') ?? 0;

  static Future<void> setCount(String id, int value) async {
    await prefs.setInt('count_$id', value);
  }

  static bool isFavorite(String id) =>
      prefs.getStringList('favorites')?.contains(id) ?? false;

  static Future<void> toggleFavorite(String id) async {
    final favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    await prefs.setStringList('favorites', favorites);
  }

  static bool get isDark => prefs.getBool('dark') ?? false;

  static Future<void> setDark(bool value) async {
    await prefs.setBool('dark', value);
  }

  static bool get isEnglish => prefs.getBool('english') ?? false;

  static Future<void> setEnglish(bool value) async {
    await prefs.setBool('english', value);
  }

  // Tasbih getter
  static int get tasbih => prefs.getInt('tasbih') ?? 0;

  static Future<void> setTasbih(int value) async {
    await prefs.setInt('tasbih', value);
  }

  static Future<String> exportData() async {
    return jsonEncode({
      'favorites': prefs.getStringList('favorites') ?? [],
      'tasbih': tasbih,
      'counts': {
        for (final key in prefs.getKeys())
          if (key.startsWith('count_'))
            key.substring(6): prefs.getInt(key) ?? 0
      }
    });
  }
}

// =====================================================
// DATA MODEL
// =====================================================

class Dhikr {
  final String id;
  final String category;
  final String arabic;
  final String english;
  final String reference;
  final int target;
  final String virtue;

  const Dhikr({
    required this.id,
    required this.category,
    required this.arabic,
    required this.english,
    required this.reference,
    required this.target,
    this.virtue = '',
  });
}

// =====================================================
// DHIKR LIBRARY
// =====================================================

const List<Dhikr> adhkar = [
  Dhikr(
    id: 'morning1',
    category: 'morning',
    arabic: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ ۞ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...',
    english: 'Ayat al-Kursi',
    reference: 'سورة البقرة: 255',
    target: 1,
  ),
  Dhikr(
    id: 'morning2',
    category: 'morning',
    arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۞ اللَّهُ الصَّمَدُ ۞ لَمْ يَلِدْ وَلَمْ يُولَدْ ۞ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
    english: 'Surah Al-Ikhlas',
    reference: 'سورة الإخلاص',
    target: 3,
  ),
  Dhikr(
    id: 'morning3',
    category: 'morning',
    arabic: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۞ مِن شَرِّ مَا خَلَقَ ۞ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ۞ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۞ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
    english: 'Surah Al-Falaq',
    reference: 'سورة الفلق',
    target: 3,
  ),
  Dhikr(
    id: 'morning4',
    category: 'morning',
    arabic: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۞ مَلِكِ النَّاسِ ۞ إِلَٰهِ النَّاسِ ۞ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۞ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۞ مِنَ الْجِنَّةِ وَالنَّاسِ',
    english: 'Surah An-Nas',
    reference: 'سورة الناس',
    target: 3,
  ),
  Dhikr(
    id: 'morning5',
    category: 'morning',
    arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
    english: 'We have entered the morning and the dominion belongs to Allah.',
    reference: 'رواه مسلم',
    target: 1,
  ),
  Dhikr(
    id: 'evening1',
    category: 'evening',
    arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
    english: 'We have entered the evening and the dominion belongs to Allah.',
    reference: 'رواه مسلم',
    target: 1,
  ),
  Dhikr(
    id: 'after1',
    category: 'afterPrayer',
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    english: 'I seek forgiveness from Allah.',
    reference: 'رواه مسلم',
    target: 3,
  ),
  Dhikr(
    id: 'after2',
    category: 'afterPrayer',
    arabic: 'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
    english: 'O Allah, You are Peace and from You comes peace.',
    reference: 'رواه مسلم',
    target: 1,
  ),
  Dhikr(
    id: 'after3',
    category: 'afterPrayer',
    arabic: 'سُبْحَانَ اللَّهِ',
    english: 'Glory be to Allah.',
    reference: 'رواه مسلم',
    target: 33,
  ),
  Dhikr(
    id: 'after4',
    category: 'afterPrayer',
    arabic: 'الْحَمْدُ لِلَّهِ',
    english: 'All praise is for Allah.',
    reference: 'رواه مسلم',
    target: 33,
  ),
  Dhikr(
    id: 'after5',
    category: 'afterPrayer',
    arabic: 'اللَّهُ أَكْبَرُ',
    english: 'Allah is the Greatest.',
    reference: 'رواه مسلم',
    target: 33,
  ),
  Dhikr(
    id: 'general1',
    category: 'general',
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    english: 'Glory and praise be to Allah.',
    reference: 'متفق عليه',
    target: 100,
  ),
  Dhikr(
    id: 'general2',
    category: 'general',
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
    english: 'There is no deity except Allah alone, without partner.',
    reference: 'متفق عليه',
    target: 100,
  ),
  Dhikr(
    id: 'general3',
    category: 'general',
    arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
    english: 'I seek forgiveness from Allah and repent to Him.',
    reference: 'متفق عليه',
    target: 100,
  ),
  Dhikr(
    id: 'sleep1',
    category: 'sleep',
    arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    english: 'In Your name, O Allah, I die and I live.',
    reference: 'رواه البخاري',
    target: 1,
  ),
  Dhikr(
    id: 'wake1',
    category: 'wake',
    arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
    english: 'Praise be to Allah who gave us life after causing us to die.',
    reference: 'رواه البخاري',
    target: 1,
  ),
];

// =====================================================
// APP
// =====================================================

class RifqApp extends StatefulWidget {
  const RifqApp({super.key});

  @override
  State<RifqApp> createState() => _RifqAppState();
}

class _RifqAppState extends State<RifqApp> {
  bool dark = AppStorage.isDark;

  void toggleTheme() async {
    setState(() => dark = !dark);
    await AppStorage.setDark(dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رفيق الأذكار',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7FAF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F8B68),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7FAF7),
          centerTitle: true,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 6),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF75B58D),
          brightness: Brightness.dark,
        ),
        cardTheme: const CardThemeData(elevation: 0),
      ),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        onThemeChanged: toggleTheme,
        dark: dark,
      ),
    );
  }
}

// =====================================================
// HOME PAGE
// =====================================================

class HomePage extends StatefulWidget {
  final VoidCallback onThemeChanged;
  final bool dark;

  const HomePage({
    super.key,
    required this.onThemeChanged,
    required this.dark,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool english = AppStorage.isEnglish;

  String t(String ar, String en) => english ? en : ar;

  @override
  Widget build(BuildContext context) {
    final titles = [
      t('الرئيسية', 'Home'),
      t('الأذكار', 'Adhkar'),
      t('السبحة', 'Tasbih'),
      t('المفضلة', 'Favorites'),
    ];

    final page = [
      DashboardPage(english: english),
      LibraryPage(english: english),
      TasbihPage(english: english),
      FavoritesPage(english: english),
    ];

    return Directionality(
      textDirection: english ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            selectedIndex == 0 ? 'رفيق الأذكار' : titles[selectedIndex],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                widget.dark ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: widget.onThemeChanged,
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'language') {
                  setState(() => english = !english);
                  await AppStorage.setEnglish(english);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'language',
                  child: Text(t('تغيير اللغة', 'Change language')),
                ),
              ],
            ),
          ],
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: page,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (i) {
            setState(() => selectedIndex = i);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: t('الرئيسية', 'Home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              label: t('الأذكار', 'Adhkar'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.radio_button_checked),
              label: t('السبحة', 'Tasbih'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_outline),
              label: t('المفضلة', 'Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// DASHBOARD
// =====================================================

class DashboardPage extends StatefulWidget {
  final bool english;

  const DashboardPage({super.key, required this.english});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String t(String ar, String en) => widget.english ? en : ar;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3F805C),
                Color(0xFF8DBB98),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t('السلام عليك ورحمة الله', 'Peace be upon you'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                t(
                  'اجعل لسانك رطبًا بذكر الله',
                  'Keep your tongue moist with the remembrance of Allah',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 18),
              const Icon(
                Icons.spa_outlined,
                color: Colors.white,
                size: 48,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          t('ابدأ يومك', 'Start your day'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        _quickCard(
          context,
          Icons.wb_sunny_outlined,
          t('أذكار الصباح', 'Morning Adhkar'),
          t('ابدأ صباحك بذكر الله', 'Start your morning with remembrance'),
          'morning',
        ),
        _quickCard(
          context,
          Icons.nights_stay_outlined,
          t('أذكار المساء', 'Evening Adhkar'),
          t('اختم يومك بالذكر', 'End your day with remembrance'),
          'evening',
        ),
        _quickCard(
          context,
          Icons.mosque_outlined,
          t('أذكار بعد الصلاة', 'After Prayer'),
          t('أذكار دبر الصلوات', 'Remembrances after prayer'),
          'afterPrayer',
        ),
        const SizedBox(height: 16),
        Text(
          t('من فضل الذكر', 'About remembrance'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              '﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                height: 1.8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _quickCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String category,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE6F2E9),
          child: Icon(
            icon,
            color: const Color(0xFF3F805C),
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryPage(
                category: category,
                english: widget.english,
              ),
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// LIBRARY
// =====================================================

class LibraryPage extends StatefulWidget {
  final bool english;

  const LibraryPage({super.key, required this.english});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String search = '';
  String category = 'all';

  String t(String ar, String en) => widget.english ? en : ar;

  @override
  Widget build(BuildContext context) {
    final categories = {
      'all': t('الكل', 'All'),
      'morning': t('الصباح', 'Morning'),
      'evening': t('المساء', 'Evening'),
      'afterPrayer': t('بعد الصلاة', 'After Prayer'),
      'general': t('أذكار عامة', 'General'),
      'sleep': t('النوم', 'Sleep'),
      'wake': t('الاستيقاظ', 'Waking up'),
    };

    final results = adhkar.where((d) {
      final matchesCategory =
          category == 'all' || d.category == category;

      final matchesSearch =
          d.arabic.contains(search) ||
          d.english.toLowerCase().contains(search.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: TextField(
            decoration: InputDecoration(
              hintText: t('ابحث عن ذكر...', 'Search adhkar...'),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (v) => setState(() => search = v),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: categories.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(e.value),
                  selected: category == e.key,
                  onSelected: (_) {
                    setState(() => category = e.key);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Text(t('لا توجد نتائج', 'No results')),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: results.length,
                  itemBuilder: (_, i) => DhikrCard(
                    key: ValueKey(results[i].id),
                    dhikr: results[i],
                    english: widget.english,
                  ),
                ),
        ),
      ],
    );
  }
}

// =====================================================
// CATEGORY PAGE
// =====================================================

class CategoryPage extends StatelessWidget {
  final String category;
  final bool english;

  const CategoryPage({
    super.key,
    required this.category,
    required this.english,
  });

  @override
  Widget build(BuildContext context) {
    final items = adhkar.where((d) => d.category == category).toList();

    return Directionality(
      textDirection: english ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(english ? 'Adhkar' : 'الأذكار'),
        ),
        body: items.isEmpty
            ? Center(
                child: Text(
                  english ? 'No adhkar available' : 'لا توجد أذكار',
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, i) => DhikrCard(
                  key: ValueKey(items[i].id),
                  dhikr: items[i],
                  english: english,
                ),
              ),
      ),
    );
  }
}

// =====================================================
// DHIKR CARD
// =====================================================

class DhikrCard extends StatefulWidget {
  final Dhikr dhikr;
  final bool english;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.english,
  });

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  late int count;
  late bool favorite;

  @override
  void initState() {
    super.initState();
    count = AppStorage.getCount(widget.dhikr.id);
    favorite = AppStorage.isFavorite(widget.dhikr.id);
  }

  Future<void> increment() async {
    if (count >= widget.dhikr.target) {
      HapticFeedback.lightImpact();
      return;
    }

    setState(() => count++);

    await AppStorage.setCount(
      widget.dhikr.id,
      count,
    );

    if (count == widget.dhikr.target) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.dhikr;
    final english = widget.english;

    final double progress = d.target > 0
        ? (count / d.target).clamp(0.0, 1.0).toDouble()
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    english ? d.english : d.reference,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite ? Colors.red : null,
                  ),
                  onPressed: () async {
                    await AppStorage.toggleFavorite(d.id);

                    if (mounted) {
                      setState(() => favorite = !favorite);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              d.arabic,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                height: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              english ? d.reference : 'المصدر: ${d.reference}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '${english ? 'Count' : 'التكرار'}: $count / ${d.target}',
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    setState(() => count = 0);
                    await AppStorage.setCount(d.id, 0);
                  },
                  icon: const Icon(Icons.refresh),
                ),
                FilledButton(
                  onPressed: increment,
                  child: Text(english ? 'Count +1' : 'تسبيح +1'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// FAVORITES
// =====================================================

class FavoritesPage extends StatefulWidget {
  final bool english;

  const FavoritesPage({super.key, required this.english});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final favorites = adhkar
        .where((d) => AppStorage.isFavorite(d.id))
        .toList();

    return favorites.isEmpty
        ? Center(
            child: Text(
              widget.english
                  ? 'No favorite adhkar yet'
                  : 'لم تضف أذكارًا للمفضلة بعد',
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (_, i) => DhikrCard(
              key: ValueKey(favorites[i].id),
              dhikr: favorites[i],
              english: widget.english,
            ),
          );
  }
}

// =====================================================
// TASBIH
// =====================================================

class TasbihPage extends StatefulWidget {
  final bool english;

  const TasbihPage({super.key, required this.english});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  late int count;
  int target = 33;

  @override
  void initState() {
    super.initState();
    count = AppStorage.tasbih;
  }

  String t(String ar, String en) => widget.english ? en : ar;

  Future<void> increment() async {
    setState(() => count++);

    await AppStorage.setTasbih(count);

    HapticFeedback.selectionClick();
  }

  Future<void> reset() async {
    setState(() => count = 0);

    await AppStorage.setTasbih(0);
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        (count / target).clamp(0.0, 1.0).toDouble();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              t('السبحة الإلكترونية', 'Digital Tasbih'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 35),
            Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 7,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(t('عدد التسبيحات', 'Total count')),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Text('${(progress * 100).round()}%'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
            ),
            const SizedBox(height: 25),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [33, 99, 100].map((v) {
                return ChoiceChip(
                  label: Text('$v'),
                  selected: target == v,
                  onSelected: (_) {
                    setState(() => target = v);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 180,
              height: 65,
              child: FilledButton(
                onPressed: increment,
                child: Text(
                  t('سبّح', 'Count'),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: reset,
              icon: const Icon(Icons.refresh),
              label: Text(t('إعادة التصفير', 'Reset')),
            ),
          ],
        ),
      ),
    );
  }
}