import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HisnCategory {
  final int id;
  final String englishTitle;
  final String arabicTitle;
  final List<HisnDua> duas;

  const HisnCategory({
    required this.id,
    required this.englishTitle,
    required this.arabicTitle,
    required this.duas,
  });
}

class HisnDua {
  final int id;
  final String arabicText;
  final String englishText;
  final int repeatCount;

  const HisnDua({
    required this.id,
    required this.arabicText,
    required this.englishText,
    required this.repeatCount,
  });
}

class HisnMuslimScreen extends StatefulWidget {
  const HisnMuslimScreen({super.key});

  @override
  State<HisnMuslimScreen> createState() => _HisnMuslimScreenState();
}

class _HisnMuslimScreenState extends State<HisnMuslimScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<HisnCategory> _allCategories = <HisnCategory>[];
  List<HisnCategory> _filteredCategories = <HisnCategory>[];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadHisnDataset();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHisnDataset() async {
    try {
      final results = await Future.wait<String>([
        rootBundle.loadString('assets/data/hisn_ar.json'),
        rootBundle.loadString('assets/data/hisn_en.json'),
      ]);

      final List<dynamic> arList = json.decode(results[0]) as List<dynamic>;
      final List<dynamic> enList = json.decode(results[1]) as List<dynamic>;

      final Map<int, Map<String, dynamic>> enById =
          <int, Map<String, dynamic>>{};
      for (final rawEn in enList) {
        final map = rawEn as Map<String, dynamic>;
        final id = (map['id'] as num?)?.toInt() ?? 0;
        enById[id] = map;
      }

      final List<HisnCategory> parsed = <HisnCategory>[];

      for (final rawAr in arList) {
        final arCat = rawAr as Map<String, dynamic>;
        final catId = (arCat['id'] as num?)?.toInt() ?? 0;
        final enCat = enById[catId];

        final arTitle = (arCat['category'] ?? '').toString().trim();
        final enTitle = (enCat?['category'] ?? arTitle).toString().trim();

        final List<dynamic> arItems =
            (arCat['array'] as List<dynamic>?) ?? <dynamic>[];
        final List<dynamic> enItems =
            (enCat?['array'] as List<dynamic>?) ?? <dynamic>[];

        final List<HisnDua> duas = <HisnDua>[];
        for (int i = 0; i < arItems.length; i++) {
          final arItem = arItems[i] as Map<String, dynamic>;
          final enItem = i < enItems.length
              ? enItems[i] as Map<String, dynamic>
              : <String, dynamic>{};

          final duaId = (arItem['id'] as num?)?.toInt() ?? (i + 1);
          final arabicText = (arItem['text'] ?? '').toString().trim();
          final englishText = (enItem['text'] ?? '').toString().trim();
          final count = (arItem['count'] as num?)?.toInt() ?? 1;

          duas.add(
            HisnDua(
              id: duaId,
              arabicText: arabicText,
              englishText: englishText,
              repeatCount: count > 0 ? count : 1,
            ),
          );
        }

        parsed.add(
          HisnCategory(
            id: catId,
            englishTitle: enTitle,
            arabicTitle: arTitle,
            duas: duas,
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _allCategories = parsed;
        _filteredCategories = parsed;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Could not load Hisn al-Muslim data. Confirm hisn_ar.json and hisn_en.json are inside assets/data/.\n\nDetails: $e';
        _isLoading = false;
      });
    }
  }

  void _filterCategories(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      setState(() => _filteredCategories = _allCategories);
      return;
    }

    setState(() {
      _filteredCategories = _allCategories.where((cat) {
        return cat.englishTitle.toLowerCase().contains(trimmed) ||
            cat.arabicTitle.contains(trimmed) ||
            cat.id.toString() == trimmed;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3C2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hisn al-Muslim',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Fortress of the Muslim',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00B060)),
            )
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterCategories,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText:
                          'Search 132 chapters (e.g. Sleep, Travel, Rain)...',
                      hintStyle: const TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF00B060),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white54,
                                size: 18,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _filterCategories('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFF1F2325),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                    itemCount: _filteredCategories.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final category = _filteredCategories[index];
                      return Material(
                        color: const Color(0xFF1F2325),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    HisnChapterDetailScreen(category: category),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00B060)
                                        .withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${category.id}',
                                    style: const TextStyle(
                                      color: Color(0xFF00B060),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.englishTitle,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${category.duas.length} ${category.duas.length == 1 ? "supplication" : "supplications"}',
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class HisnChapterDetailScreen extends StatefulWidget {
  final HisnCategory category;

  const HisnChapterDetailScreen({super.key, required this.category});

  @override
  State<HisnChapterDetailScreen> createState() =>
      _HisnChapterDetailScreenState();
}

class _HisnChapterDetailScreenState extends State<HisnChapterDetailScreen> {
  final Map<int, int> _tapCounts = <int, int>{};
  double _arabicFontSize = 26.0;
  bool _showTranslation = true;
  bool _hapticsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _arabicFontSize = prefs.getDouble('arabic_font_size') ?? 26.0;
      _showTranslation = prefs.getBool('show_translation') ?? true;
      _hapticsEnabled = prefs.getBool('haptics_enabled') ?? true;
    });
  }

  Future<void> _incrementDua(int index, int target) async {
    final current = _tapCounts[index] ?? 0;
    if (current >= target) return;

    final next = current + 1;
    if (_hapticsEnabled) {
      if (next == target) {
        await HapticFeedback.heavyImpact();
      } else {
        await HapticFeedback.mediumImpact();
      }
    }

    if (!mounted) return;
    setState(() {
      _tapCounts[index] = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3C2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.category.englishTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.category.duas.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final dua = widget.category.duas[index];
          final currentCount = _tapCounts[index] ?? 0;
          final isComplete = currentCount >= dua.repeatCount;

          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2325),
              borderRadius: BorderRadius.circular(18),
              border: isComplete
                  ? Border.all(
                      color: const Color(0xFF00B060).withValues(alpha: 0.6),
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  dua.arabicText,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _arabicFontSize,
                    height: 1.85,
                    fontFamily: 'Amiri',
                  ),
                ),
                if (_showTranslation &&
                    dua.englishText.isNotEmpty &&
                    dua.englishText != dua.arabicText) ...[
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFF2B3033), height: 1),
                  const SizedBox(height: 14),
                  Text(
                    dua.englishText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.55,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recite ${dua.repeatCount}x',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _incrementDua(index, dua.repeatCount),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: isComplete
                              ? const Color(0xFF007A43)
                              : const Color(0xFF00B060),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isComplete
                              ? 'Completed (${dua.repeatCount}/${dua.repeatCount})'
                              : 'Tap $currentCount / ${dua.repeatCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
