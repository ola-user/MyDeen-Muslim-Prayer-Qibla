import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/surah.dart';
import '../services/api_service.dart';
import '../services/global_audio_service.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final ApiService apiService = ApiService();
  final GlobalAudioService audioService = GlobalAudioService.instance;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late Future<List<Surah>> _surahsFuture;
  Timer? _searchDebounce;

  String _lastReadSurah = 'Al-Faatiha';
  String _lastReadVerse = '1:1';
  String _lastPlayedSurah = 'Al-Baqara';
  String _lastPlayedVerse = '2:1';
  List<Surah> _surahs = [];

  bool _isSearching = false;
  String _searchQuery = '';
  bool _isSearchingVerses = false;
  List<Map<String, dynamic>> _verseMatches = [];

  static const List<Map<String, dynamic>> _transliterationShortcuts = [
    {
      'keywords': ['ayatul kursi', 'ayat al kursi', 'ayat kursi', 'kursi'],
      'title': 'Ayatul Kursi',
      'subtitle': 'Al-Baqara • 2:255',
      'surahNumber': 2,
      'verseNumber': 255,
    },
    {
      'keywords': ['bismillah', 'bismillahir rahmanir rahim'],
      'title': 'Bismillahir-Rahmanir-Rahim',
      'subtitle': 'Al-Faatiha • 1:1',
      'surahNumber': 1,
      'verseNumber': 1,
    },
    {
      'keywords': ['alhamdulillah', 'alhamdu lillah', 'rabbil alamin'],
      'title': 'Alhamdulillahi Rabbil-Alamin',
      'subtitle': 'Al-Faatiha • 1:2',
      'surahNumber': 1,
      'verseNumber': 2,
    },
    {
      'keywords': ['iyyaka nabudu', 'iyyaka na\'budu', 'iyyaka nastain'],
      'title': 'Iyyaka Na\'budu wa Iyyaka Nasta\'in',
      'subtitle': 'Al-Faatiha • 1:5',
      'surahNumber': 1,
      'verseNumber': 5,
    },
    {
      'keywords': ['ihdinas sirat', 'siratal mustaqim', 'sirat al mustaqim'],
      'title': 'Ihdinas-Siratal-Mustaqim',
      'subtitle': 'Al-Faatiha • 1:6',
      'surahNumber': 1,
      'verseNumber': 6,
    },
    {
      'keywords': ['rabbana atina', 'fid dunya hasanah'],
      'title': 'Rabbana Atina Fid-Dunya Hasanah',
      'subtitle': 'Al-Baqara • 2:201',
      'surahNumber': 2,
      'verseNumber': 201,
    },
    {
      'keywords': ['amanar rasulu', 'amanar rasul'],
      'title': 'Amanar-Rasulu (Last 2 Verses of Al-Baqara)',
      'subtitle': 'Al-Baqara • 2:285',
      'surahNumber': 2,
      'verseNumber': 285,
    },
    {
      'keywords': ['la yukallifullahu', 'la yukallifu'],
      'title': 'La Yukallifullahu Nafsan Illa Wus\'aha',
      'subtitle': 'Al-Baqara • 2:286',
      'surahNumber': 2,
      'verseNumber': 286,
    },
    {
      'keywords': [
        'hasbunallah',
        'hasbunallahu',
        'ni\'mal wakil',
        'nimal wakil',
      ],
      'title': 'Hasbunallahu wa Ni\'mal-Wakil',
      'subtitle': 'Aal-i-Imraan • 3:173',
      'surahNumber': 3,
      'verseNumber': 173,
    },
    {
      'keywords': ['kullu nafsin', 'zaiqatul mawt'],
      'title': 'Kullu Nafsin Dha\'iqatul-Mawt',
      'subtitle': 'Aal-i-Imraan • 3:185',
      'surahNumber': 3,
      'verseNumber': 185,
    },
    {
      'keywords': ['inshallah', 'inshaallah', 'insha allah'],
      'title': 'Illa An Yasha\'allah (Insha\'Allah)',
      'subtitle': 'Al-Kahf • 18:23',
      'surahNumber': 18,
      'verseNumber': 23,
    },
    {
      'keywords': ['mashallah', 'mashaallah', 'la quwwata illa billah'],
      'title': 'Masha\'Allah La Quwwata Illa Billah',
      'subtitle': 'Al-Kahf • 18:39',
      'surahNumber': 18,
      'verseNumber': 39,
    },
    {
      'keywords': ['rabbi ishrah', 'ishrah li sadri'],
      'title': 'Rabbi Ishrah Li Sadri',
      'subtitle': 'Taa-Haa • 20:25',
      'surahNumber': 20,
      'verseNumber': 25,
    },
    {
      'keywords': ['rabbi zidni ilma', 'zidni ilma'],
      'title': 'Rabbi Zidni Ilma',
      'subtitle': 'Taa-Haa • 20:114',
      'surahNumber': 20,
      'verseNumber': 114,
    },
    {
      'keywords': ['la ilaha illa anta', 'subhanaka inni kuntu', 'dua yunus'],
      'title': 'La Ilaha Illa Anta Subhanaka (Dua of Yunus)',
      'subtitle': 'Al-Anbiyaa • 21:87',
      'surahNumber': 21,
      'verseNumber': 87,
    },
    {
      'keywords': ['ayat nur', 'ayat un nur', 'allahu nurus samawati'],
      'title': 'Ayat an-Nur (Verse of Light)',
      'subtitle': 'An-Noor • 24:35',
      'surahNumber': 24,
      'verseNumber': 35,
    },
    {
      'keywords': ['inna maal usri', 'inna ma\'al usri', 'maal usri yusra'],
      'title': 'Fa Inna Ma\'al-Usri Yusra',
      'subtitle': 'Ash-Sharh • 94:5',
      'surahNumber': 94,
      'verseNumber': 5,
    },
    {
      'keywords': ['qul huwallahu ahad', 'huwallahu ahad', 'surah ikhlas'],
      'title': 'Qul Huwallahu Ahad',
      'subtitle': 'Al-Ikhlaas • 112:1',
      'surahNumber': 112,
      'verseNumber': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _surahsFuture = apiService.getSurahs();
    _loadMemory();
    GlobalAudioService.instance.addListener(_onAudioUpdate);
  }

  Future<void> _loadMemory() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lastReadSurah = prefs.getString('lastReadSurah') ?? 'Al-Faatiha';
      _lastReadVerse = prefs.getString('lastReadVerse') ?? '1:1';
      _lastPlayedSurah = prefs.getString('lastPlayedSurah') ?? 'Al-Baqara';
      _lastPlayedVerse = prefs.getString('lastPlayedVerse') ?? '2:1';
    });
  }

  void _onAudioUpdate() {
    _loadMemory();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    _searchDebounce?.cancel();
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _isSearchingVerses = false;
      _verseMatches = [];
    });
  }

  void _onSearchChanged(String value) {
    final trimmed = value.trim();
    setState(() {
      _searchQuery = trimmed;
    });

    _searchDebounce?.cancel();

    // Skip remote search if query is empty or is a direct "Surah:Verse" reference
    final isDirectRef = RegExp(r'^\d{1,3}:\d{1,3}$').hasMatch(trimmed);
    if (trimmed.length < 2 || isDirectRef) {
      setState(() {
        _isSearchingVerses = false;
        _verseMatches = [];
      });
      return;
    }

    setState(() {
      _isSearchingVerses = true;
    });

    _searchDebounce = Timer(const Duration(milliseconds: 450), () async {
      try {
        final results = await apiService.searchVerses(trimmed);
        if (!mounted || _searchQuery != trimmed) return;
        setState(() {
          _verseMatches = results;
          _isSearchingVerses = false;
        });
      } catch (_) {
        if (!mounted || _searchQuery != trimmed) return;
        setState(() {
          _verseMatches = [];
          _isSearchingVerses = false;
        });
      }
    });
  }

  Surah _resolveSurah(
    int surahNum, {
    String? fallbackEnglish,
    String? fallbackArabic,
  }) {
    return _surahs.firstWhere(
      (s) => s.number == surahNum,
      orElse: () => Surah.fromJson({
        'number': surahNum,
        'name': fallbackArabic ?? 'سورة $surahNum',
        'englishName': fallbackEnglish ?? 'Surah $surahNum',
        'englishNameTranslation': '',
      }),
    );
  }

  Future<void> _openSurahAtVerse({
    required int surahNum,
    required int verseNum,
    String? fallbackEnglish,
    String? fallbackArabic,
    bool isPlayed = false,
  }) async {
    _searchFocusNode.unfocus();
    final surah = _resolveSurah(
      surahNum,
      fallbackEnglish: fallbackEnglish,
      fallbackArabic: fallbackArabic,
    );

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahDetailScreen(
          surah: surah,
          initialVerseNumber: verseNum,
          isFromLastPlayed: isPlayed,
        ),
      ),
    );
    _loadMemory();
  }

  Future<void> _openSavedVerse({required bool isPlayed}) async {
    final prefs = await SharedPreferences.getInstance();
    final ref = isPlayed ? _lastPlayedVerse : _lastReadVerse;
    final parts = ref.split(':');

    final surahNum =
        (isPlayed
            ? prefs.getInt('lastPlayedSurahNumber')
            : prefs.getInt('lastReadSurahNumber')) ??
        (parts.isNotEmpty ? int.tryParse(parts[0]) : null) ??
        1;
    final verseNum =
        (isPlayed
            ? prefs.getInt('lastPlayedVerseNumber')
            : prefs.getInt('lastReadVerseNumber')) ??
        (parts.length > 1 ? int.tryParse(parts[1]) : null) ??
        1;

    await _openSurahAtVerse(
      surahNum: surahNum,
      verseNum: verseNum,
      fallbackEnglish: isPlayed ? _lastPlayedSurah : _lastReadSurah,
      isPlayed: isPlayed,
    );
  }

  String _normalizeLatin(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  List<Surah> _filterSurahs(List<Surah> allSurahs, String query) {
    if (query.isEmpty) return allSurahs;
    final qLower = query.toLowerCase();
    final qNorm = _normalizeLatin(query);

    return allSurahs.where((surah) {
      if ('${surah.number}' == qLower) return true;
      if (surah.name.contains(query)) return true;
      if (surah.englishName.toLowerCase().contains(qLower)) return true;
      if (surah.englishNameTranslation.toLowerCase().contains(qLower)) {
        return true;
      }
      if (qNorm.isNotEmpty &&
          _normalizeLatin(surah.englishName).contains(qNorm)) {
        return true;
      }
      return false;
    }).toList();
  }

  List<Map<String, dynamic>> _filterTransliterations(String query) {
    if (query.length < 3) return [];
    final qLower = query.toLowerCase();
    final qNorm = _normalizeLatin(query);

    return _transliterationShortcuts.where((entry) {
      final keywords = entry['keywords'] as List<String>;
      return keywords.any((kw) {
        if (kw.contains(qLower) || qLower.contains(kw)) return true;
        final kwNorm = _normalizeLatin(kw);
        return qNorm.length >= 4 &&
            (kwNorm.contains(qNorm) || qNorm.contains(kwNorm));
      });
    }).toList();
  }

  Map<String, int>? _parseVerseReference(String query) {
    final match = RegExp(r'^(\d{1,3}):(\d{1,3})$').firstMatch(query);
    if (match == null) return null;
    final surahNum = int.tryParse(match.group(1)!);
    final verseNum = int.tryParse(match.group(2)!);
    if (surahNum == null ||
        verseNum == null ||
        surahNum < 1 ||
        surahNum > 114 ||
        verseNum < 1) {
      return null;
    }
    return {'surah': surahNum, 'verse': verseNum};
  }

  TextSpan _buildHighlightedText(
    String text,
    String query, {
    required bool isArabic,
  }) {
    final baseStyle = TextStyle(
      color: Colors.white70,
      fontSize: isArabic ? 20 : 14,
      height: 1.5,
      fontFamily: isArabic ? 'Amiri' : null,
    );

    if (query.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        break;
      }
      if (index > start) {
        spans.add(
          TextSpan(text: text.substring(start, index), style: baseStyle),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: baseStyle.copyWith(
            color: const Color(0xFF00B060),
            fontWeight: FontWeight.bold,
            backgroundColor: const Color(0xFF00B060).withValues(alpha: 0.16),
          ),
        ),
      );
      start = index + query.length;
    }

    return TextSpan(children: spans);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    GlobalAudioService.instance.removeListener(_onAudioUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141718),
        elevation: 0,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _closeSearch,
              )
            : null,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                cursorColor: const Color(0xFF00B060),
                decoration: InputDecoration(
                  hintText: 'Search Surah, English, Arabic, or 2:255...',
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1F2325),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white54,
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                ),
              )
            : const Text(
                'Quran',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: _isSearching
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: _startSearch,
                ),
              ],
      ),
      body: Column(
        children: [
          if (!_isSearching) ...[
            _buildTopCards(),
            const Divider(color: Color(0xFF262A2D), height: 1, thickness: 1),
          ],
          Expanded(
            child: FutureBuilder<List<Surah>>(
              future: _surahsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00B060)),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Error loading data',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                if (!snapshot.hasData) return const SizedBox();

                final allSurahs = snapshot.data!;
                _surahs = allSurahs;

                if (_isSearching && _searchQuery.isNotEmpty) {
                  return _buildSearchResults(allSurahs);
                }

                return _buildSurahListView(allSurahs);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Surah> allSurahs) {
    final directRef = _parseVerseReference(_searchQuery);
    final transliterationHits = _filterTransliterations(_searchQuery);
    final matchingSurahs = _filterSurahs(allSurahs, _searchQuery);

    final hasNoLocalResults =
        directRef == null &&
        transliterationHits.isEmpty &&
        matchingSurahs.isEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        // 1. Direct Surah:Verse reference (e.g. 2:255)
        if (directRef != null) ...[
          _buildSectionLabel('Direct Verse Jump'),
          const SizedBox(height: 8),
          _buildQuickJumpCard(
            title:
                '${_resolveSurah(directRef['surah']!).englishName} (${directRef['surah']}:${directRef['verse']})',
            subtitle: 'Tap to jump directly to Verse ${directRef['verse']}',
            onTap: () => _openSurahAtVerse(
              surahNum: directRef['surah']!,
              verseNum: directRef['verse']!,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 2. Transliteration / Popular Phrase Matches
        if (transliterationHits.isNotEmpty) ...[
          _buildSectionLabel('Matched Phrases & Verses'),
          const SizedBox(height: 8),
          ...transliterationHits.map(
            (hit) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildQuickJumpCard(
                title: hit['title'] as String,
                subtitle: hit['subtitle'] as String,
                onTap: () => _openSurahAtVerse(
                  surahNum: hit['surahNumber'] as int,
                  verseNum: hit['verseNumber'] as int,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // 3. Matching Surahs
        if (matchingSurahs.isNotEmpty) ...[
          _buildSectionLabel('Surahs (${matchingSurahs.length})'),
          const SizedBox(height: 8),
          ...matchingSurahs.map(_buildSurahTile),
          const SizedBox(height: 16),
        ],

        // 4. Matching Verses from Quran Search
        if (_searchQuery.length >= 2 && directRef == null) ...[
          _buildSectionLabel('Verses in Quran'),
          const SizedBox(height: 8),
          if (_isSearchingVerses)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF00B060)),
              ),
            )
          else if (_verseMatches.isEmpty && hasNoLocalResults)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No matching Surahs or verses found.',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
            )
          else if (_verseMatches.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No exact verse text matches found.',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            )
          else
            ..._verseMatches.map(_buildVerseMatchCard),
        ],
      ],
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF00B060),
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.4,
      ),
    );
  }

  Widget _buildQuickJumpCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF00B060).withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00B060).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFF00B060),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _buildVerseMatchCard(Map<String, dynamic> match) {
    final surahNum = match['surahNumber'] as int;
    final verseNum = match['numberInSurah'] as int;
    final surahEnglish = match['surahEnglishName'] as String;
    final surahArabic = match['surahName'] as String;
    final text = match['text'] as String;
    final isArabic = match['isArabic'] as bool;

    return GestureDetector(
      onTap: () => _openSurahAtVerse(
        surahNum: surahNum,
        verseNum: verseNum,
        fallbackEnglish: surahEnglish,
        fallbackArabic: surahArabic,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2325),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B060).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$surahEnglish • $surahNum:$verseNum',
                    style: const TextStyle(
                      color: Color(0xFF00B060),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  surahArabic,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    fontFamily: 'Amiri',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text.rich(
              _buildHighlightedText(text, _searchQuery, isArabic: isArabic),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahListView(List<Surah> surahs) {
    return ListView.separated(
      itemCount: surahs.length,
      separatorBuilder: (context, index) =>
          const Divider(color: Color(0xFF262A2D), height: 1),
      itemBuilder: (context, index) => _buildSurahTile(surahs[index]),
    );
  }

  Widget _buildSurahTile(Surah surah) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/star_border.png')),
        ),
        child: Text(
          '${surah.number}',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
      title: Row(
        children: [
          Text(
            surah.englishName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            surah.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Amiri',
            ),
          ),
        ],
      ),
      subtitle: Text(
        surah.englishNameTranslation,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: () async {
        _searchFocusNode.unfocus();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahDetailScreen(surah: surah),
          ),
        );
        _loadMemory();
      },
    );
  }

  Widget _buildTopCards() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // CARD 1: Last Recitation
          Expanded(
            child: GestureDetector(
              onTap: () => _openSavedVerse(isPlayed: false),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2325),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _lastReadSurah,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _lastReadVerse,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Last Recitation',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                        Icon(
                          Icons.bookmark_border,
                          color: Colors.blueAccent,
                          size: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // CARD 2: Last Played
          Expanded(
            child: GestureDetector(
              onTap: () => _openSavedVerse(isPlayed: true),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2325),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _lastPlayedSurah,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _lastPlayedVerse,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Last Played',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF00B060),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Color(0xFF00B060),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
