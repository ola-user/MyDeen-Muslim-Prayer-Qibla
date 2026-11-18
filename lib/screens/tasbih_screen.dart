import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _count = 0;
  int _lifetimeCount = 0;
  int _target = 33;
  int _selectedDhikrIndex = 0;

  static const List<Map<String, String>> _dhikrPresets = [
    {
      'arabic': 'سُبْحَانَ اللَّهِ',
      'transliteration': 'SubhanAllah',
      'meaning': 'Glory be to Allah',
    },
    {
      'arabic': 'الْحَمْدُ لِلَّهِ',
      'transliteration': 'Alhamdulillah',
      'meaning': 'All praise is due to Allah',
    },
    {
      'arabic': 'اللَّهُ أَكْبَرُ',
      'transliteration': 'Allahu Akbar',
      'meaning': 'Allah is the Greatest',
    },
    {
      'arabic': 'أَسْتَغْفِرُ اللَّهَ',
      'transliteration': 'Astaghfirullah',
      'meaning': 'I seek forgiveness from Allah',
    },
    {
      'arabic': 'لَا إِلَٰهَ إِلَّا اللَّهُ',
      'transliteration': 'La ilaha illallah',
      'meaning': 'There is no deity worthy of worship except Allah',
    },
  ];

  static const List<int> _targets = [33, 99, 100, 0]; // 0 = Unlimited

  @override
  void initState() {
    super.initState();
    _loadTasbihState();
  }

  Future<void> _loadTasbihState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _count = prefs.getInt('tasbih_current_count') ?? 0;
      _lifetimeCount = prefs.getInt('tasbih_lifetime_count') ?? 0;
      _target = prefs.getInt('tasbih_target') ?? 33;
      _selectedDhikrIndex = prefs.getInt('tasbih_dhikr_index') ?? 0;
    });
  }

  Future<void> _saveTasbihState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_current_count', _count);
    await prefs.setInt('tasbih_lifetime_count', _lifetimeCount);
    await prefs.setInt('tasbih_target', _target);
    await prefs.setInt('tasbih_dhikr_index', _selectedDhikrIndex);
  }

  Future<void> _incrementCount() async {
    final nextCount = _count + 1;
    final reachedTarget = _target > 0 && nextCount == _target;

    if (reachedTarget) {
      await HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 90));
      await HapticFeedback.heavyImpact();
    } else {
      await HapticFeedback.mediumImpact();
    }

    if (!mounted) return;
    setState(() {
      _count = nextCount;
      _lifetimeCount += 1;
    });
    await _saveTasbihState();
  }

  Future<void> _resetCount() async {
    await HapticFeedback.selectionClick();
    if (!mounted) return;
    setState(() {
      _count = 0;
    });
    await _saveTasbihState();
  }

  Future<void> _cycleTarget() async {
    await HapticFeedback.selectionClick();
    final nextIdx = (_targets.indexOf(_target) + 1) % _targets.length;
    setState(() {
      _target = _targets[nextIdx];
    });
    await _saveTasbihState();
  }

  @override
  Widget build(BuildContext context) {
    final currentDhikr = _dhikrPresets[_selectedDhikrIndex];
    final progress = _target > 0 ? (_count / _target).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF00B060).withValues(alpha: 0.3),
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Digital Tasbih',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B060).withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF00B060).withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      'Total: $_lifetimeCount',
                      style: const TextStyle(
                        color: Color(0xFF00B060),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dhikrPresets.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedDhikrIndex;
                return GestureDetector(
                  onTap: () async {
                    await HapticFeedback.selectionClick();
                    setState(() {
                      _selectedDhikrIndex = index;
                      _count = 0;
                    });
                    await _saveTasbihState();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF00B060)
                          : const Color(0xFF1F2325),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _dhikrPresets[index]['transliteration']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2325),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    currentDhikr['arabic']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Amiri',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentDhikr['transliteration']!,
                    style: const TextStyle(
                      color: Color(0xFF00B060),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentDhikr['meaning']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _incrementCount,
            child: SizedBox(
              width: 230,
              height: 230,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 230,
                    height: 230,
                    child: CircularProgressIndicator(
                      value: _target > 0 ? progress : 1.0,
                      strokeWidth: 8,
                      backgroundColor: const Color(0xFF1F2325),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF00B060),
                      ),
                    ),
                  ),
                  Container(
                    width: 202,
                    height: 202,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: const Color(0xFF00B060).withValues(alpha: 0.45),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _target > 0 ? 'of $_target' : 'Tap to count',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _cycleTarget,
                  icon: const Icon(
                    Icons.flag_outlined,
                    color: Color(0xFF00B060),
                    size: 18,
                  ),
                  label: Text(_target > 0 ? 'Target: $_target' : 'Target: ∞'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _resetCount,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.orangeAccent,
                    size: 18,
                  ),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
