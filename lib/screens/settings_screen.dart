import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';
import '../services/prayer_service.dart';
import 'location_picker_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PrayerService _prayerService = PrayerService();

  String _cityName = 'Loading...';
  List<dynamic>? _monthData;

  int _calcMethod = 3; // 3 = Muslim World League
  int _asrMadhab = 0; // 0 = Shafi'i / Standard, 1 = Hanafi
  bool _hapticsEnabled = true;
  double _arabicFontSize = 28.0;
  bool _showTransliteration = true;
  bool _showTranslation = true;

  final Map<String, bool> _prayerReminders = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  static const Map<int, String> _calculationMethods = {
    3: 'Muslim World League (MWL)',
    2: 'Islamic Society of North America (ISNA)',
    5: 'Egyptian General Authority of Survey',
    4: 'Umm Al-Qura University, Makkah',
    1: 'University of Islamic Sciences, Karachi',
    12: 'Union Organization Islamic de France',
    13: 'Diyanet İşleri Başkanlığı, Turkey',
  };

  @override
  void initState() {
    super.initState();
    _loadAllSettings();
  }

  Future<void> _loadAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _calcMethod = prefs.getInt('prayer_calc_method') ?? 3;
      _asrMadhab = prefs.getInt('prayer_asr_madhab') ?? 0;
      _hapticsEnabled = prefs.getBool('haptics_enabled') ?? true;
      _arabicFontSize = prefs.getDouble('arabic_font_size') ?? 28.0;
      _showTransliteration = prefs.getBool('show_transliteration') ?? true;
      _showTranslation = prefs.getBool('show_translation') ?? true;

      for (final prayer in _prayerReminders.keys) {
        _prayerReminders[prayer] = prefs.getBool('reminder_$prayer') ?? true;
      }
    });

    try {
      final result = await _prayerService.getPrayerTimesAndLocation();
      if (!mounted) return;
      setState(() {
        _cityName = result['cityName'] ?? 'Unknown Location';
        _monthData = result['monthData'];
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cityName = 'Tap to select city';
      });
    }
  }

  Future<void> _changeLocation() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectCityScreen(currentLocationLabel: _cityName),
      ),
    );

    if (updated == true && mounted) {
      setState(() => _cityName = 'Updating...');
      await _loadAllSettings();
      if (!kIsWeb && _monthData != null) {
        NotificationService.autoScheduleAllMonth(_monthData!);
      }
    }
  }

  Future<void> _selectCalculationMethod() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A1E20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Prayer Calculation Method',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ..._calculationMethods.entries.map((entry) {
                  final selected = entry.key == _calcMethod;
                  return ListTile(
                    title: Text(
                      entry.value,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFF00B060)
                            : Colors.white,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check, color: Color(0xFF00B060))
                        : null,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('prayer_calc_method', entry.key);
                      if (!mounted) return;
                      setState(() => _calcMethod = entry.key);
                      if (context.mounted) Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectAsrMadhab() async {
    final options = {
      0: "Shafi'i, Maliki, Hanbali (Standard)",
      1: 'Hanafi (Later Asr)',
    };

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A1E20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Asr Juristic Method',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ...options.entries.map((entry) {
                  final selected = entry.key == _asrMadhab;
                  return ListTile(
                    title: Text(
                      entry.value,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFF00B060)
                            : Colors.white,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check, color: Color(0xFF00B060))
                        : null,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('prayer_asr_madhab', entry.key);
                      if (!mounted) return;
                      setState(() => _asrMadhab = entry.key);
                      if (context.mounted) Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _togglePrayerReminder(String prayer, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_$prayer', enabled);

    if (!kIsWeb && _monthData != null) {
      NotificationService.autoScheduleAllMonth(_monthData!);
    }

    if (!mounted) return;
    setState(() {
      _prayerReminders[prayer] = enabled;
    });
  }

  Future<void> _confirmResetTasbih() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2325),
        title: const Text(
          'Reset Tasbih Counter?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will reset your current and lifetime Tasbih counts back to 0.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('tasbih_current_count', 0);
      await prefs.setInt('tasbih_lifetime_count', 0);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tasbih counters reset to 0.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3C2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('Prayer & Location'),
          _buildCard(
            children: [
              _buildActionTile(
                icon: Icons.location_on_outlined,
                title: 'City / Location',
                subtitle: _cityName,
                onTap: _changeLocation,
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.calculate_outlined,
                title: 'Calculation Method',
                subtitle: _calculationMethods[_calcMethod] ?? 'MWL',
                onTap: _selectCalculationMethod,
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.access_time_outlined,
                title: 'Asr Juristic Method',
                subtitle: _asrMadhab == 1 ? 'Hanafi' : "Shafi'i / Standard",
                onTap: _selectAsrMadhab,
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildSectionHeader('Prayer Notifications'),
          _buildCard(
            children: List.generate(_prayerReminders.length, (index) {
              final prayer = _prayerReminders.keys.elementAt(index);
              final isLast = index == _prayerReminders.length - 1;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    activeThumbColor: const Color(0xFF00B060),
                    title: Text(
                      '$prayer Adhan Reminder',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    value: _prayerReminders[prayer] ?? true,
                    onChanged: (val) => _togglePrayerReminder(prayer, val),
                  ),
                  if (!isLast) _buildDivider(),
                ],
              );
            }),
          ),
          const SizedBox(height: 22),
          _buildSectionHeader('Reading & Feedback'),
          _buildCard(
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                activeThumbColor: const Color(0xFF00B060),
                title: const Text(
                  'Haptic Vibration',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                subtitle: const Text(
                  'Vibrate when tapping Tasbih and Azkar counters',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                value: _hapticsEnabled,
                onChanged: (val) async {
                  if (val) HapticFeedback.mediumImpact();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('haptics_enabled', val);
                  if (!mounted) return;
                  setState(() => _hapticsEnabled = val);
                },
              ),
              _buildDivider(),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                activeThumbColor: const Color(0xFF00B060),
                title: const Text(
                  'Show Transliteration',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                value: _showTransliteration,
                onChanged: (val) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('show_transliteration', val);
                  if (!mounted) return;
                  setState(() => _showTransliteration = val);
                },
              ),
              _buildDivider(),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                activeThumbColor: const Color(0xFF00B060),
                title: const Text(
                  'Show English Translation',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                value: _showTranslation,
                onChanged: (val) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('show_translation', val);
                  if (!mounted) return;
                  setState(() => _showTranslation = val);
                },
              ),
              _buildDivider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Arabic Font Size',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          '${_arabicFontSize.round()} pt',
                          style: const TextStyle(
                            color: Color(0xFF00B060),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _arabicFontSize,
                      min: 22,
                      max: 38,
                      divisions: 8,
                      activeColor: const Color(0xFF00B060),
                      inactiveColor: Colors.white24,
                      onChanged: (val) {
                        setState(() => _arabicFontSize = val);
                      },
                      onChangeEnd: (val) async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setDouble('arabic_font_size', val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildSectionHeader('Data'),
          _buildCard(
            children: [
              _buildActionTile(
                icon: Icons.refresh_rounded,
                iconColor: Colors.orangeAccent,
                title: 'Reset Tasbih Counters',
                subtitle: 'Clear current and lifetime Tasbih totals',
                onTap: _confirmResetTasbih,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF00B060),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2325),
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    Color iconColor = const Color(0xFF00B060),
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white54,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF2B3033),
      height: 1,
      thickness: 1,
      indent: 52,
    );
  }
}
