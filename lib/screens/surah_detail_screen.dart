import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/surah.dart';
import '../services/api_service.dart';
import '../services/global_audio_service.dart';

class SurahDetailScreen extends StatefulWidget {
  final Surah surah;
  final int? initialVerseNumber;
  final bool isFromLastPlayed;

  const SurahDetailScreen({
    super.key,
    required this.surah,
    this.initialVerseNumber,
    this.isFromLastPlayed = false,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final GlobalAudioService _audio = GlobalAudioService.instance;
  final ApiService _apiService = ApiService();
  final List<TapGestureRecognizer> _recognizers = [];
  final ScrollController _listScrollController = ScrollController();
  final ScrollController _mushafScrollController = ScrollController();

  PageController? _surahPageController;
  List<Surah> _surahs = [];
  final Map<int, List<dynamic>> _pageVerses = {};
  final Map<int, GlobalKey> _verseKeys = {};
  final Map<int, GlobalKey> _mushafVerseKeys = {};
  int _activePageIndex = 0;
  int _lastPlayingSurahNumber = 1;

  int? _selectedVerseIndex;
  int? _highlightedLastPlayedIndex;
  bool _isMushafMode = false;
  bool _isLoadingVerses = true;
  bool _isProgrammaticSwipe = false;
  int? _pendingInitialVerse;

  int _currentJuz = 1;
  int _currentHizb = 1;

  Timer? _saveReadDebounceTimer;
  String? _latestReadSurahName;
  int? _latestReadSurahNumber;
  int? _latestReadVerseNumber;

  Surah _getSurahByNumber(int surahNumber) {
    if (_surahs.length >= surahNumber && surahNumber >= 1) {
      return _surahs[surahNumber - 1];
    }
    if (widget.surah.number == surahNumber) {
      return widget.surah;
    }
    return Surah.fromJson({
      'number': surahNumber,
      'name': 'سورة $surahNumber',
      'englishName': 'Surah $surahNumber',
      'englishNameTranslation': '',
    });
  }

  @override
  void initState() {
    super.initState();
    _activePageIndex = widget.surah.number - 1;
    _lastPlayingSurahNumber = _audio.currentSurahNumber;
    _pendingInitialVerse = widget.initialVerseNumber;
    _surahPageController = PageController(initialPage: _activePageIndex);
    _loadViewPreference();
    _audio.addListener(_onAudioChanged);
    _initSurahListAndPage();
  }

  Future<void> _initSurahListAndPage() async {
    if (_audio.allSurahs.isEmpty) {
      try {
        _audio.allSurahs = await _apiService.getSurahs();
      } catch (_) {}
    }
    _surahs = _audio.allSurahs;

    final verses = await _audio.fetchVersesForSurah(widget.surah.number);
    _pageVerses[widget.surah.number] = verses;
    _syncJuzHizbFromVerses(verses, _pendingInitialVerse ?? 1);

    if (widget.isFromLastPlayed && verses.isNotEmpty) {
      final targetVerse = _pendingInitialVerse ?? 1;
      final targetIndex = (targetVerse - 1).clamp(0, verses.length - 1);
      _highlightedLastPlayedIndex = targetIndex;

      if (!_audio.isPlaying) {
        await _audio.prepareSurahAtVerse(widget.surah, verses, targetIndex);
      }
    } else {
      if (!_audio.isPlaying) {
        await _audio.loadSurah(widget.surah, autoPlay: false);
      }
      final startVerse = _pendingInitialVerse ?? 1;
      _recordLastRead(widget.surah, startVerse, immediate: true);
    }

    if (!mounted) return;
    setState(() {
      _isLoadingVerses = false;
    });

    if (_pendingInitialVerse != null && verses.isNotEmpty) {
      final targetVerse = _pendingInitialVerse!;
      _pendingInitialVerse = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _jumpToVerse(targetVerse, verses);
      });
    }
  }

  void _syncJuzHizbFromVerses(List<dynamic> verses, int verseNumber) {
    if (verses.isEmpty) return;
    final idx = (verseNumber - 1).clamp(0, verses.length - 1);
    final v = verses[idx];
    _currentJuz = (v['juz'] as int?) ?? 1;
    _currentHizb = (v['hizb'] as int?) ?? 1;
  }

  void _jumpToVerse(int verseNumber, List<dynamic> verses) {
    final totalVerses = verses.length;
    if (!mounted || totalVerses <= 0) return;
    final targetIndex = (verseNumber - 1).clamp(0, totalVerses - 1);

    if (_isMushafMode) {
      if (!_mushafScrollController.hasClients) return;
      final maxScroll = _mushafScrollController.position.maxScrollExtent;
      final ratio = totalVerses > 1 ? targetIndex / (totalVerses - 1) : 0.0;
      _mushafScrollController.jumpTo((ratio * maxScroll).clamp(0.0, maxScroll));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _mushafVerseKeys[targetIndex]?.currentContext;
        if (ctx != null && ctx.mounted) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0.25,
            duration: const Duration(milliseconds: 250),
          );
        }
      });
    } else {
      if (!_listScrollController.hasClients) return;
      final maxScroll = _listScrollController.position.maxScrollExtent;
      final estimatedOffset = (targetIndex * 165.0).clamp(0.0, maxScroll);
      _listScrollController.jumpTo(estimatedOffset);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _verseKeys[targetIndex]?.currentContext;
        if (ctx != null && ctx.mounted) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0.15,
            duration: const Duration(milliseconds: 250),
          );
        }
      });
    }
  }

  void _recordLastRead(
    Surah surah,
    int verseNumberInSurah, {
    bool immediate = false,
  }) {
    _latestReadSurahName = surah.englishName;
    _latestReadSurahNumber = surah.number;
    _latestReadVerseNumber = verseNumberInSurah;

    _saveReadDebounceTimer?.cancel();
    if (immediate) {
      _flushLastReadToPrefs();
    } else {
      _saveReadDebounceTimer = Timer(
        const Duration(milliseconds: 300),
        _flushLastReadToPrefs,
      );
    }
  }

  Future<void> _flushLastReadToPrefs() async {
    final name = _latestReadSurahName;
    final surahNum = _latestReadSurahNumber;
    final verseNum = _latestReadVerseNumber;
    if (name == null || surahNum == null || verseNum == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastReadSurah', name);
    await prefs.setString('lastReadVerse', '$surahNum:$verseNum');
    await prefs.setInt('lastReadSurahNumber', surahNum);
    await prefs.setInt('lastReadVerseNumber', verseNum);
  }

  void _handleScrollReadingProgress(List<dynamic> verses, Surah viewedSurah) {
    if (verses.isEmpty) return;

    if (_isMushafMode) {
      if (!_mushafScrollController.hasClients) return;
      final maxScroll = _mushafScrollController.position.maxScrollExtent;
      final ratio = maxScroll <= 0
          ? 0.0
          : (_mushafScrollController.offset / maxScroll).clamp(0.0, 1.0);
      final idx = (ratio * (verses.length - 1)).round().clamp(
        0,
        verses.length - 1,
      );
      final verse = verses[idx];
      final verseNum = verse['numberInSurah'] as int;
      _recordLastRead(viewedSurah, verseNum);

      final newJuz = (verse['juz'] as int?) ?? _currentJuz;
      final newHizb = (verse['hizb'] as int?) ?? _currentHizb;
      if (newJuz != _currentJuz || newHizb != _currentHizb) {
        setState(() {
          _currentJuz = newJuz;
          _currentHizb = newHizb;
        });
      }
    } else {
      int? topVisibleVerseNum;
      double bestTop = double.infinity;

      for (final entry in _verseKeys.entries) {
        final ctx = entry.value.currentContext;
        if (ctx == null || !ctx.mounted) continue;
        final renderObj = ctx.findRenderObject();
        if (renderObj is! RenderBox || !renderObj.hasSize) continue;

        final topY = renderObj.localToGlobal(Offset.zero).dy;
        final bottomY = topY + renderObj.size.height;

        if (bottomY > 110 && topY < bestTop) {
          bestTop = topY;
          final idx = entry.key;
          if (idx >= 0 && idx < verses.length) {
            topVisibleVerseNum = verses[idx]['numberInSurah'] as int;
          }
        }
      }

      if (topVisibleVerseNum != null) {
        _recordLastRead(viewedSurah, topVisibleVerseNum);
      }
    }
  }

  void _onAudioChanged() {
    if (!mounted) return;

    if (_audio.isPlaying && _highlightedLastPlayedIndex != null) {
      _highlightedLastPlayedIndex = null;
    }

    final audioPageIdx = _audio.currentSurahNumber - 1;
    if (_audio.currentSurahNumber != _lastPlayingSurahNumber &&
        _activePageIndex == _lastPlayingSurahNumber - 1 &&
        audioPageIdx >= 0 &&
        audioPageIdx < 114 &&
        _surahPageController?.hasClients == true) {
      _activePageIndex = audioPageIdx;
      _isProgrammaticSwipe = true;
      _surahPageController
          ?.animateToPage(
            audioPageIdx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
          .then((_) {
            if (mounted) {
              setState(() {
                _isProgrammaticSwipe = false;
              });
            } else {
              _isProgrammaticSwipe = false;
            }
          });
    }
    _lastPlayingSurahNumber = _audio.currentSurahNumber;

    setState(() {});
  }

  Future<void> _onSurahSwiped(int pageIndex) async {
    _verseKeys.clear();
    _mushafVerseKeys.clear();
    setState(() {
      _activePageIndex = pageIndex;
      _selectedVerseIndex = null;
      _highlightedLastPlayedIndex = null;
    });

    final targetSurah = _getSurahByNumber(pageIndex + 1);
    _recordLastRead(targetSurah, 1, immediate: true);

    if (!_pageVerses.containsKey(targetSurah.number)) {
      setState(() {
        _isLoadingVerses = true;
      });
      final verses = await _audio.fetchVersesForSurah(targetSurah.number);
      _pageVerses[targetSurah.number] = verses;
    }

    final loadedVerses = _pageVerses[targetSurah.number] ?? [];
    _syncJuzHizbFromVerses(loadedVerses, 1);

    if (!_isProgrammaticSwipe && !_audio.isPlaying) {
      await _audio.loadSurah(targetSurah, autoPlay: false);
    }

    if (!mounted) return;
    setState(() {
      _isLoadingVerses = false;
    });
  }

  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isMushafMode = prefs.getBool('quranMushafMode') ?? false;
    });
  }

  Future<void> _toggleViewMode() async {
    final nextMode = !_isMushafMode;
    setState(() {
      _isMushafMode = nextMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quranMushafMode', nextMode);
  }

  Future<void> _showVerseMenu(
    BuildContext context,
    int index,
    Offset tapPosition,
  ) async {
    final viewedSurah = _getSurahByNumber(_activePageIndex + 1);
    final verses = _pageVerses[viewedSurah.number] ?? [];
    if (index >= 0 && index < verses.length) {
      _recordLastRead(
        viewedSurah,
        verses[index]['numberInSurah'] as int,
        immediate: true,
      );
    }

    setState(() {
      _selectedVerseIndex = index;
      _highlightedLastPlayedIndex = null;
    });

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final choice = await showMenu<String>(
      context: context,
      color: const Color(0xFF252729),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx, tapPosition.dy + 8, 1, 1),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem<String>(
          value: 'play_from_here',
          child: Row(
            children: [
              Icon(Icons.play_arrow, color: Colors.white, size: 22),
              SizedBox(width: 12),
              Text(
                'Play continuously from here',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'repeat_ayah',
          child: Row(
            children: [
              Icon(Icons.repeat_one, color: Colors.white, size: 22),
              SizedBox(width: 12),
              Text(
                'Repeat selected Ayah',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );

    if (!mounted) return;

    if (choice == 'play_from_here') {
      await _audio.playSurahFromVerse(
        viewedSurah,
        verses,
        index,
        repeatSingle: false,
      );
    } else if (choice == 'repeat_ayah') {
      await _audio.playSurahFromVerse(
        viewedSurah,
        verses,
        index,
        repeatSingle: true,
      );
    }

    if (mounted) {
      setState(() {
        _selectedVerseIndex = null;
      });
    }
  }

  void _clearRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  String _toArabicDigits(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicDigits[int.parse(d)])
        .join();
  }

  String _cleanMushafArabic(String rawText, int surahNum, int verseNum) {
    var text = rawText.trim();
    if (surahNum != 1 && surahNum != 9 && verseNum == 1) {
      const bismillahVariants = [
        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      ];
      for (final prefix in bismillahVariants) {
        if (text.startsWith(prefix)) {
          text = text.substring(prefix.length).trim();
          break;
        }
      }
    }
    return text;
  }

  String _shortArabicSurahName(String fullArabicName) {
    return fullArabicName
        .replaceFirst('سُورَةُ ', '')
        .replaceFirst('سورة ', '')
        .trim();
  }

  @override
  void dispose() {
    _saveReadDebounceTimer?.cancel();
    _flushLastReadToPrefs();
    _listScrollController.dispose();
    _mushafScrollController.dispose();
    _clearRecognizers();
    _surahPageController?.dispose();
    _audio.removeListener(_onAudioChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewedSurah = _getSurahByNumber(_activePageIndex + 1);
    final surahNum = viewedSurah.number;
    final surahEnglish = viewedSurah.englishName;
    final surahArabic = viewedSurah.name;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isMushafMode ? '$surahArabic ▾' : '$surahEnglish ▾',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              'Surah $surahNum • Swipe to change Surah',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isMushafMode
                ? 'Switch to Arabic + English'
                : 'Switch to Quran Format',
            icon: Icon(
              _isMushafMode ? Icons.translate : Icons.menu_book_rounded,
              color: _isMushafMode ? Colors.greenAccent : Colors.white,
            ),
            onPressed: _toggleViewMode,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _surahPageController,
              reverse: true,
              itemCount: 114,
              onPageChanged: _onSurahSwiped,
              itemBuilder: (context, pageIndex) {
                final pageSurah = _getSurahByNumber(pageIndex + 1);
                final verses = _pageVerses[pageSurah.number] ?? [];
                if ((_isLoadingVerses && verses.isEmpty) || verses.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  );
                }

                return _isMushafMode
                    ? _buildMushafView(
                        pageSurah.number,
                        pageSurah.name,
                        verses,
                        pageSurah,
                      )
                    : _buildTranslationListView(
                        pageSurah.number,
                        verses,
                        pageSurah,
                      );
              },
            ),
          ),
          _buildBottomPlayer(_audio.currentSurahEnglish),
        ],
      ),
    );
  }

  Widget _buildMushafView(
    int surahNum,
    String surahArabic,
    List<dynamic> verses,
    Surah viewedSurah,
  ) {
    _clearRecognizers();

    final Map<int, List<int>> pageGroups = {};
    final List<int> orderedPages = [];
    for (int i = 0; i < verses.length; i++) {
      final p = (verses[i]['page'] as int?) ?? 1;
      if (!pageGroups.containsKey(p)) {
        pageGroups[p] = [];
        orderedPages.add(p);
      }
      pageGroups[p]!.add(i);
    }

    final firstVerse = verses.first;
    final isCurrentViewed =
        viewedSurah.number == _getSurahByNumber(_activePageIndex + 1).number;
    final headerJuz =
        isCurrentViewed ? _currentJuz : ((firstVerse['juz'] as int?) ?? 1);
    final headerHizb =
        isCurrentViewed ? _currentHizb : ((firstVerse['hizb'] as int?) ?? 1);

    return Container(
      color: const Color(0xFF141414),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Juz $headerJuz, Hizb $headerHizb',
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _shortArabicSurahName(surahArabic),
                      style: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 15,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.auto_stories_outlined,
                      color: Color(0xFF9E9E9E),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification ||
                    notification is ScrollEndNotification) {
                  _handleScrollReadingProgress(verses, viewedSurah);
                }
                return false;
              },
              child: ListView.builder(
                controller: _mushafScrollController,
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
                itemCount: orderedPages.length,
                itemBuilder: (context, pageIdx) {
                  final mushafPageNum = orderedPages[pageIdx];
                  final verseIndices = pageGroups[mushafPageNum]!;

                  final spans = <InlineSpan>[];
                  for (final index in verseIndices) {
                    final verse = verses[index];
                    final verseNum = verse['numberInSurah'] as int;
                    final arabicText = _cleanMushafArabic(
                      verse['arabic'] as String,
                      surahNum,
                      verseNum,
                    );
                    final verseKey = _mushafVerseKeys.putIfAbsent(
                      index,
                      () => GlobalKey(),
                    );

                    final isSelected = _selectedVerseIndex == index;
                    final isSavedLastPlayed =
                        surahNum == widget.surah.number &&
                        _highlightedLastPlayedIndex == index;
                    final isCurrentPlaying =
                        _audio.activeMode == 'quran' &&
                        _audio.currentSurahNumber == surahNum &&
                        _audio.isPlaying &&
                        _audio.currentVerseIndex == index;

                    Offset lastTap = Offset.zero;
                    final recognizer = TapGestureRecognizer();
                    recognizer.onTapDown = (details) =>
                        lastTap = details.globalPosition;
                    recognizer.onTap = () =>
                        _showVerseMenu(context, index, lastTap);
                    _recognizers.add(recognizer);

                    Color? highlightColor;
                    if (isSelected) {
                      highlightColor = const Color(0xFF1F3A52);
                    } else if (isCurrentPlaying || isSavedLastPlayed) {
                      highlightColor = Colors.green.withValues(alpha: 0.22);
                    }

                    spans.add(
                      TextSpan(
                        text: '$arabicText\u00A0',
                        recognizer: recognizer,
                        style: TextStyle(
                          color: const Color(0xFFE8E6E1),
                          backgroundColor: highlightColor,
                          fontSize: 26,
                          height: 2.15,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    );

                    spans.add(
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          key: verseKey,
                          onTapDown: (details) =>
                              lastTap = details.globalPosition,
                          onTap: () => _showVerseMenu(context, index, lastTap),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: _AyahEndMedallion(
                              arabicDigits: _toArabicDigits(verseNum),
                              isPlaying:
                                  isCurrentPlaying || isSavedLastPlayed,
                              isSelected: isSelected,
                            ),
                          ),
                        ),
                      ),
                    );

                    spans.add(const TextSpan(text: ' '));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (pageIdx == 0) ...[
                        _OrnateSurahBanner(surahArabic: surahArabic),
                        if (surahNum != 1 && surahNum != 9) ...[
                          const SizedBox(height: 14),
                          const _CalligraphicBismillah(),
                        ],
                        const SizedBox(height: 14),
                      ] else
                        const SizedBox(height: 14),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text.rich(
                          TextSpan(children: spans),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          '$mushafPageNum',
                          style: const TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        color: Color(0xFF2B2B2B),
                        thickness: 1,
                        height: 1,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationListView(
    int surahNum,
    List<dynamic> verses,
    Surah viewedSurah,
  ) {
    final showBismillahHeader = surahNum != 1 && surahNum != 9;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification) {
          _handleScrollReadingProgress(verses, viewedSurah);
        }
        return false;
      },
      child: ListView.separated(
        controller: _listScrollController,
        padding: const EdgeInsets.all(16),
        itemCount: verses.length + (showBismillahHeader ? 1 : 0),
        separatorBuilder: (context, index) =>
            const Divider(color: Color(0xFF2A2A2A), height: 40),
        itemBuilder: (context, listIndex) {
          if (showBismillahHeader && listIndex == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontFamily: 'Amiri',
                ),
              ),
            );
          }

          final index = showBismillahHeader ? listIndex - 1 : listIndex;
          final verse = verses[index];
          final verseKey = _verseKeys.putIfAbsent(index, () => GlobalKey());
          final isSelected = _selectedVerseIndex == index;
          final isSavedLastPlayed =
              surahNum == widget.surah.number &&
              _highlightedLastPlayedIndex == index;
          final isCurrentVerse =
              _audio.activeMode == 'quran' &&
              _audio.currentSurahNumber == surahNum &&
              _audio.isPlaying &&
              _audio.currentVerseIndex == index;

          Color? cardColor;
          if (isSelected) {
            cardColor = const Color(0xFF1F3A52);
          } else if (isCurrentVerse || isSavedLastPlayed) {
            cardColor = Colors.green.withValues(alpha: 0.14);
          }

          Offset lastTap = Offset.zero;

          return GestureDetector(
            key: verseKey,
            onTapDown: (details) => lastTap = details.globalPosition,
            onTap: () => _showVerseMenu(context, index, lastTap),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cardColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E1E1E),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${verse['numberInSurah']}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          verse['arabic'],
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            height: 1.5,
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    verse['english'],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomPlayer(String surahEnglish) {
    String statusLabel =
        '$surahEnglish - Verse ${_audio.currentVerseIndex + 1}';
    if (_audio.repeatMode == 1) {
      statusLabel += ' (Repeat Ayah)';
    } else if (_audio.repeatMode == 2) {
      statusLabel += ' (Repeat Unlimited)';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _audio.cycleSpeed,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _audio.playbackSpeed != 1.0
                        ? Colors.green.withValues(alpha: 0.2)
                        : const Color(0xFF262626),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _audio.playbackSpeed != 1.0
                          ? Colors.green
                          : Colors.white24,
                    ),
                  ),
                  child: Text(
                    '${_audio.playbackSpeed}x',
                    style: TextStyle(
                      color: _audio.playbackSpeed != 1.0
                          ? Colors.greenAccent
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _audio.player.hasPrevious
                        ? () => _audio.player.seekToPrevious()
                        : null,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: (!_audio.isReady || _audio.isLoading)
                        ? null
                        : () async {
                            if (_audio.isPlaying) {
                              await _audio.player.pause();
                            } else {
                              await _audio.player.play();
                            }
                          },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: (!_audio.isReady || _audio.isLoading)
                          ? const SizedBox(
                              width: 36,
                              height: 36,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Icon(
                              _audio.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 36,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _audio.player.hasNext
                        ? () => _audio.player.seekToNext()
                        : null,
                  ),
                ],
              ),
              IconButton(
                onPressed: _audio.cycleRepeatMode,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.repeat,
                      color: _audio.repeatMode > 0
                          ? Colors.green
                          : Colors.white54,
                      size: 28,
                    ),
                    if (_audio.repeatMode > 0)
                      Positioned(
                        top: -6,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _audio.repeatMode == 1 ? '1' : '∞',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            statusLabel,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _OrnateSurahBanner extends StatelessWidget {
  final String surahArabic;

  const _OrnateSurahBanner({required this.surahArabic});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: CustomPaint(
        painter: _SurahBannerPainter(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 68),
            child: Text(
              surahArabic,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFEAE8E3),
                fontSize: 23,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurahBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cy = h / 2;

    final borderPaint = Paint()
      ..color = const Color(0xFF9E9D99)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final subtlePaint = Paint()
      ..color = const Color(0xFF6E6D6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    final fillPaint = Paint()
      ..color = const Color(0xFF1C1C1E)
      ..style = PaintingStyle.fill;

    const wingWidth = 54.0;
    final innerLeft = wingWidth;
    final innerRight = w - wingWidth;

    final cartoucheRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(innerLeft, 7, innerRight, h - 7),
      const Radius.circular(14),
    );
    canvas.drawRRect(cartoucheRect, fillPaint);
    canvas.drawRRect(cartoucheRect, borderPaint);

    final innerCartouche = RRect.fromRectAndRadius(
      Rect.fromLTRB(innerLeft + 4, 10.5, innerRight - 4, h - 10.5),
      const Radius.circular(11),
    );
    canvas.drawRRect(innerCartouche, subtlePaint);

    _drawArabesqueWing(
      canvas,
      innerLeft,
      cy,
      h,
      borderPaint,
      subtlePaint,
      fillPaint,
      isLeft: true,
    );
    _drawArabesqueWing(
      canvas,
      innerRight,
      cy,
      h,
      borderPaint,
      subtlePaint,
      fillPaint,
      isLeft: false,
    );
  }

  void _drawArabesqueWing(
    Canvas canvas,
    double anchorX,
    double cy,
    double h,
    Paint stroke,
    Paint subtle,
    Paint fill, {
    required bool isLeft,
  }) {
    final dir = isLeft ? -1.0 : 1.0;

    final wingPath = Path()
      ..moveTo(anchorX, 7)
      ..cubicTo(
        anchorX + dir * 22,
        4,
        anchorX + dir * 36,
        cy - 12,
        anchorX + dir * 48,
        cy,
      )
      ..cubicTo(
        anchorX + dir * 36,
        cy + 12,
        anchorX + dir * 22,
        h - 4,
        anchorX,
        h - 7,
      )
      ..close();

    canvas.drawPath(wingPath, fill);
    canvas.drawPath(wingPath, stroke);

    canvas.drawCircle(Offset(anchorX + dir * 18, cy), 6.5, subtle);
    canvas.drawCircle(Offset(anchorX + dir * 18, cy), 2.5, stroke);
    canvas.drawCircle(Offset(anchorX + dir * 33, cy - 6), 3.2, subtle);
    canvas.drawCircle(Offset(anchorX + dir * 33, cy + 6), 3.2, subtle);
    canvas.drawCircle(Offset(anchorX + dir * 43, cy), 2.0, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CalligraphicBismillah extends StatelessWidget {
  const _CalligraphicBismillah();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 28,
          height: 1,
          color: const Color(0xFF4A4A4A),
        ),
        const SizedBox(width: 10),
        const Text(
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFD6D4CE),
            fontSize: 21,
            fontFamily: 'Amiri',
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 28,
          height: 1,
          color: const Color(0xFF4A4A4A),
        ),
      ],
    );
  }
}

class _AyahEndMedallion extends StatelessWidget {
  final String arabicDigits;
  final bool isPlaying;
  final bool isSelected;

  const _AyahEndMedallion({
    required this.arabicDigits,
    required this.isPlaying,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ringColor = isPlaying
        ? Colors.greenAccent
        : (isSelected ? Colors.lightBlueAccent : const Color(0xFFA8A6A1));

    return SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: _AyahMedallionPainter(ringColor: ringColor),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              arabicDigits,
              style: TextStyle(
                color: isPlaying ? Colors.greenAccent : const Color(0xFFE8E6E1),
                fontSize: arabicDigits.length >= 3 ? 10 : 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AyahMedallionPainter extends CustomPainter {
  final Color ringColor;

  const _AyahMedallionPainter({required this.ringColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 1.2;
    final innerRadius = outerRadius - 3.0;

    final outerPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final innerPaint = Paint()
      ..color = ringColor.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.85;

    final rosette = Path();
    const lobes = 8;
    const steps = 64;
    for (int i = 0; i <= steps; i++) {
      final theta = (i / steps) * 2 * math.pi;
      final r = outerRadius - 1.1 + 1.1 * math.cos(lobes * theta);
      final x = center.dx + r * math.cos(theta);
      final y = center.dy + r * math.sin(theta);
      if (i == 0) {
        rosette.moveTo(x, y);
      } else {
        rosette.lineTo(x, y);
      }
    }
    rosette.close();

    canvas.drawPath(rosette, outerPaint);
    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _AyahMedallionPainter oldDelegate) {
    return oldDelegate.ringColor != ringColor;
  }
}