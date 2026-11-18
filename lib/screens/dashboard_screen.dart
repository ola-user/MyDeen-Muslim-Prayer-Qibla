import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';
import '../services/prayer_service.dart';
import 'asma_ul_husna_screen.dart';
import 'azkar_screen.dart';
import 'hijri_calendar_screen.dart';
import 'zakat_screen.dart';
import 'duas_screen.dart';
import 'hisn_muslim_screen.dart';
import 'location_picker_screen.dart';
import 'me_screen.dart';
import 'prayer_screen.dart';
import 'qibla_screen.dart';
import 'quran_screen.dart';
import 'tasbih_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PrayerService _prayerService = PrayerService();

  Map<String, dynamic>? _prayerData;
  List<dynamic>? _monthData;
  String _cityName = "Locating...";
  bool _isLoading = true;
  String _errorMessage = "";
  int _currentIndex = 0;

  String _nextPrayerName = "Loading...";
  String _nextPrayerTimeFormatted = "--:--";
  String _countdownDisplay = "-00:00:00";
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final result = await _prayerService.getPrayerTimesAndLocation();
      if (!mounted) return;
      setState(() {
        _prayerData = result['prayerData'];
        _monthData = result['monthData'];
        _cityName = result['cityName'];
        _isLoading = false;
      });

      _updateCountdown();
      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _updateCountdown(),
      );

      if (!kIsWeb && _monthData != null) {
        NotificationService.autoScheduleAllMonth(_monthData!);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _updateCountdown() {
    if (_prayerData == null) return;
    final timings = _prayerData!['timings'];
    final now = DateTime.now();

    final prayerOrder = [
      {'name': 'Fajr', 'time': timings['Fajr']},
      {'name': 'Sunrise', 'time': timings['Sunrise']},
      {'name': 'Dhuhr', 'time': timings['Dhuhr']},
      {'name': 'Asr', 'time': timings['Asr']},
      {'name': 'Maghrib', 'time': timings['Maghrib']},
      {'name': 'Isha', 'time': timings['Isha']},
    ];

    DateTime? targetTime;
    String targetName = "";

    for (var prayer in prayerOrder) {
      final rawTime = prayer['time'].toString().split(' ')[0];
      final parts = rawTime.split(':');
      final pTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      if (pTime.isAfter(now)) {
        targetTime = pTime;
        targetName = prayer['name']!;
        break;
      }
    }

    if (targetTime == null) {
      final rawTime = timings['Fajr'].toString().split(' ')[0];
      final parts = rawTime.split(':');
      targetTime = DateTime(
        now.year,
        now.month,
        now.day + 1,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      targetName = "Fajr";
    }

    final diff = targetTime.difference(now);
    final hours = diff.inHours.toString().padLeft(2, '0');
    final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');

    final hour12 = targetTime.hour > 12
        ? targetTime.hour - 12
        : (targetTime.hour == 0 ? 12 : targetTime.hour);
    final amPm = targetTime.hour >= 12 ? "PM" : "AM";
    final minFormatted = targetTime.minute.toString().padLeft(2, '0');

    if (!mounted) return;
    setState(() {
      _nextPrayerName = targetName;
      _nextPrayerTimeFormatted = "$hour12:$minFormatted $amPm";
      _countdownDisplay = "-$hours:$minutes:$seconds";
    });
  }

  Future<void> _openLocationPicker() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectCityScreen(currentLocationLabel: _cityName),
      ),
    );

    if (updated == true && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      await _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen;

    if (_isLoading) {
      activeScreen = const Center(
        child: CircularProgressIndicator(color: Color(0xFF00B060)),
      );
    } else if (_errorMessage.isNotEmpty) {
      activeScreen = Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, color: Colors.redAccent, size: 60),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B060),
                ),
                onPressed: _openLocationPicker,
                child: const Text(
                  'Select City / Country',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_currentIndex == 0) {
      activeScreen = HomeTab(
        prayerData: _prayerData!,
        monthData: _monthData,
        cityName: _cityName,
        nextPrayerName: _nextPrayerName,
        nextPrayerTimeFormatted: _nextPrayerTimeFormatted,
        countdownDisplay: _countdownDisplay,
        onLocationTap: _openLocationPicker,
        onSeeAllTap: () => setState(() => _currentIndex = 1),
      );
    } else if (_currentIndex == 1) {
      activeScreen = PrayerScreen(
        prayerData: _prayerData!,
        monthData: _monthData!,
        nextPrayerName: _nextPrayerName,
        nextPrayerTimeFormatted: _nextPrayerTimeFormatted,
        countdownDisplay: _countdownDisplay,
        cityName: _cityName,
        onLocationTap: _openLocationPicker,
      );
    } else if (_currentIndex == 2) {
      activeScreen = const AzkarScreen();
    } else if (_currentIndex == 3) {
      activeScreen = const QiblaScreen();
    } else {
      activeScreen = const MeScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      body: SafeArea(child: activeScreen),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1A1E20),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00B060),
        unselectedItemColor: Colors.white54,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled),
            label: 'Prayer',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Azkar'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Qibla'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final Map<String, dynamic> prayerData;
  final List<dynamic>? monthData;
  final String cityName;
  final String nextPrayerName;
  final String nextPrayerTimeFormatted;
  final String countdownDisplay;
  final VoidCallback onLocationTap;
  final VoidCallback onSeeAllTap;

  const HomeTab({
    super.key,
    required this.prayerData,
    this.monthData,
    required this.cityName,
    required this.nextPrayerName,
    required this.nextPrayerTimeFormatted,
    required this.countdownDisplay,
    required this.onLocationTap,
    required this.onSeeAllTap,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _lastPlayedSurah = "Al-Fatihah";
  String _lastPlayedVerse = "1:1";
  int _streakCount = 1;
  int _bestStreakCount = 1;
  final Map<String, bool> _prayerReminders = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  @override
  void initState() {
    super.initState();
    _loadLastPlayed();
    _updateDailyStreak();
    _loadReminderSettings();
  }

  String _dateKey(DateTime dt) {
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$m-$d';
  }

  Future<void> _updateDailyStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = _dateKey(now);
    final yesterdayStr = _dateKey(now.subtract(const Duration(days: 1)));

    final savedDate = prefs.getString('lastStreakDate');
    int streak = prefs.getInt('dailyStreakCount') ?? 1;
    int best = prefs.getInt('bestStreakCount') ?? 1;

    if (savedDate == null) {
      streak = 1;
    } else if (savedDate == todayStr) {
      // Already counted today
    } else if (savedDate == yesterdayStr) {
      streak += 1;
    } else {
      streak = 1;
    }

    if (streak > best) {
      best = streak;
    }

    await prefs.setString('lastStreakDate', todayStr);
    await prefs.setInt('dailyStreakCount', streak);
    await prefs.setInt('bestStreakCount', best);

    if (!mounted) return;
    setState(() {
      _streakCount = streak;
      _bestStreakCount = best;
    });
  }

  Future<void> _loadReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      for (final prayer in _prayerReminders.keys) {
        _prayerReminders[prayer] = prefs.getBool('reminder_$prayer') ?? true;
      }
    });
  }

  Future<void> _loadLastPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lastPlayedSurah = prefs.getString('lastPlayedSurah') ?? "Al-Fatihah";
      _lastPlayedVerse = prefs.getString('lastPlayedVerse') ?? "1:1";
    });
  }

  void _showStreakSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A1E20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 42,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '$_streakCount Day Streak!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Best Streak: $_bestStreakCount ${_bestStreakCount == 1 ? "day" : "days"}',
                style: const TextStyle(
                  color: Color(0xFF00B060),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Open the app daily to check prayer times, recite Quran, or complete your Azkar to keep your streak growing.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationsSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A1E20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        color: Color(0xFF00B060),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Prayer Time Reminders',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Active for ${widget.cityName}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  ..._prayerReminders.keys.map((prayer) {
                    final enabled = _prayerReminders[prayer] ?? true;
                    return SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: const Color(0xFF00B060),
                      title: Text(
                        prayer,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      value: enabled,
                      onChanged: (val) async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('reminder_$prayer', val);
                        if (!kIsWeb && widget.monthData != null) {
                          NotificationService.autoScheduleAllMonth(
                            widget.monthData!,
                          );
                        }
                        setModalState(() {
                          _prayerReminders[prayer] = val;
                        });
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hijri = widget.prayerData['date']['hijri'];
    final hijriDateText =
        "${hijri['day']} ${hijri['month']['en']} ${hijri['year']}";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: widget.onLocationTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.cityName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hijriDateText,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _showStreakSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2325),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$_streakCount",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _showNotificationsSheet,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1F2325),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: const Color(0xFF00B060).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.nextPrayerName} ${widget.nextPrayerTimeFormatted}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onSeeAllTap,
                      child: const Row(
                        children: [
                          Text(
                            "See all",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white54,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.countdownDisplay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.wb_sunny_outlined,
                      color: Color(0xFF00B060),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Recite morning dhikr after Fajr for blessings",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuranScreen()),
              ).then((_) => _loadLastPlayed());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2325),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B060).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF00B060),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Last Played",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$_lastPlayedSurah ($_lastPlayedVerse)",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Features",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 10,
            childAspectRatio: 0.85,
            children: [
              _buildFeatureItem(
                icon: Icons.book,
                label: "Al-Quran",
                color: const Color(0xFF00B060),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuranScreen()),
                ),
              ),
              _buildFeatureItem(
                icon: Icons.explore,
                label: "Qibla",
                color: Colors.blueAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QiblaScreen()),
                ),
              ),
              _buildFeatureItem(
                icon: Icons.favorite,
                label: "Azkar",
                color: Colors.tealAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AzkarScreen()),
                ),
              ),
              _buildFeatureItem(
                icon: Icons.fingerprint,
                label: "Tasbih",
                color: Colors.orangeAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TasbihScreen()),
                ),
              ),
              _buildFeatureItem(
                icon: Icons.menu_book_outlined,
                label: "Hisn al-Muslim",
                color: Colors.purpleAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HisnMuslimScreen(),
                  ),
                ),
              ),
              _buildFeatureItem(
                icon: Icons.volunteer_activism,
                label: "Du'as",
                color: Colors.pinkAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DuasScreen()),
                ),
              ),
              _buildFeatureItem(
                icon: Icons.volunteer_activism,
                label: "Zakat",
                color: Colors.pinkAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ZakatScreen()),
                ),
              ),
              _buildFeatureItem(
                icon: Icons.auto_awesome,
                label: "99 Names",
                color: Colors.tealAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AsmaUlHusnaScreen(),
                  ),
                ),
              ),
              _buildFeatureItem(
                icon: Icons.calendar_month_rounded,
                label: "Hijri",
                color: Colors.lightBlueAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HijriCalendarScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2325),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
