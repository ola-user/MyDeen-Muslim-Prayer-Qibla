import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/azkar_item.dart';
import '../models/surah.dart';
import 'api_service.dart';

class GlobalAudioService extends ChangeNotifier {
  GlobalAudioService._() {
    _init();
  }

  static final GlobalAudioService instance = GlobalAudioService._();

  final AudioPlayer player = AudioPlayer();
  final ApiService _apiService = ApiService();

  // Active mode: 'none', 'quran', 'azkar'
  String activeMode = 'none';

  // Shared player state
  bool isPlaying = false;
  bool isLoading = false;
  bool isReady = false;

  // --- QURAN STATE ---
  List<Surah> allSurahs = [];
  final Map<int, List<dynamic>> _versesCache = {};
  int currentSurahNumber = 1;
  String currentSurahEnglish = 'Al-Faatiha';
  String currentSurahArabic = 'سُورَةُ ٱلْفَاتِحَةِ';
  List<dynamic> currentVerses = [];
  int currentVerseIndex = 0;
  double playbackSpeed = 1.0;
  int repeatMode = 0; // 0 = off, 1 = repeat single ayah, 2 = repeat surah

  // --- AZKAR STATE ---
  String? activeAzkarCategory;
  List<AzkarItem> _azkarPlaylist = [];
  final List<int> _trackToAzkarIndex = [];
  final List<int> _trackRepetitionNumber = [];
  int currentAzkarIndex = 0;
  int _lastTrackedAzkarTrack = -1;

  List<AzkarItem> get azkarPlaylist => List.unmodifiable(_azkarPlaylist);

  void _init() {
    player.playerStateStream.listen((state) async {
      isPlaying = state.playing;
      isLoading =
          state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;

      if (!state.playing &&
          activeMode == 'quran' &&
          currentVerses.isNotEmpty &&
          currentVerseIndex >= 0 &&
          currentVerseIndex < currentVerses.length) {
        final verseNum =
            currentVerses[currentVerseIndex]['numberInSurah'] as int;
        await _saveLastPlayed(
          currentSurahEnglish,
          currentSurahNumber,
          verseNum,
        );
      }

      notifyListeners();

      if (state.processingState == ProcessingState.completed) {
        if (activeMode == 'quran') {
          await _handleQuranCompleted();
        } else if (activeMode == 'azkar') {
          await _handleAzkarCompleted();
        }
      }
    });

    player.currentIndexStream.listen((index) async {
      if (index == null) return;
      if (activeMode == 'quran') {
        if (index < currentVerses.length) {
          currentVerseIndex = index;
          notifyListeners();
          if (isPlaying) {
            final verseNum = currentVerses[index]['numberInSurah'] as int;
            await _saveLastPlayed(
              currentSurahEnglish,
              currentSurahNumber,
              verseNum,
            );
          }
        }
      } else if (activeMode == 'azkar') {
        if (index != _lastTrackedAzkarTrack &&
            index < _trackToAzkarIndex.length) {
          await _onAzkarTrackReached(index);
        }
      }
    });
  }

  // ==================== QURAN METHODS ====================

  Future<List<dynamic>> fetchVersesForSurah(int surahNumber) async {
    if (_versesCache.containsKey(surahNumber)) {
      return _versesCache[surahNumber]!;
    }
    final verses = await _apiService.getSurahVerses(surahNumber);
    _versesCache[surahNumber] = verses;
    return verses;
  }

  Future<List<dynamic>> loadSurah(Surah surah, {bool autoPlay = false}) async {
    if (allSurahs.isEmpty) {
      try {
        allSurahs = await _apiService.getSurahs();
      } catch (_) {}
    }

    if (activeMode == 'quran' &&
        currentSurahNumber == surah.number &&
        currentVerses.isNotEmpty) {
      if (autoPlay && !isPlaying) {
        await player.play();
      }
      return currentVerses;
    }

    if (activeMode == 'quran' && isPlaying && !autoPlay) {
      return await fetchVersesForSurah(surah.number);
    }

    isLoading = true;
    isReady = false;
    activeMode = 'quran';
    currentSurahNumber = surah.number;
    currentSurahEnglish = surah.englishName;
    currentSurahArabic = surah.name;
    currentVerseIndex = 0;
    notifyListeners();

    final verses = await fetchVersesForSurah(surah.number);
    currentVerses = verses;

    final sources = verses.map((verse) {
      final globalAyah = verse['number'];
      final verseNum = verse['numberInSurah'];
      return AudioSource.uri(
        Uri.parse(
          'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$globalAyah.mp3',
        ),
        tag: MediaItem(
          id: 'surah_${surah.number}_ayah_$verseNum',
          album: surah.englishName,
          title: '${surah.englishName} - Verse $verseNum',
          artist: 'Mishary Rashid Alafasy',
        ),
      );
    }).toList();

    await player.stop();
    await player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      preload: false,
    );
    await player.setSpeed(playbackSpeed);
    await _applyRepeatMode();

    isReady = true;
    isLoading = false;
    notifyListeners();

    if (autoPlay) {
      await player.play();
      await _saveLastPlayed(surah.englishName, surah.number, 1);
    }

    return verses;
  }

  Future<void> prepareSurahAtVerse(
    Surah surah,
    List<dynamic> verses,
    int index,
  ) async {
    if (verses.isEmpty) return;
    final safeIndex = index.clamp(0, verses.length - 1);

    if (activeMode == 'quran' &&
        currentSurahNumber == surah.number &&
        isReady &&
        currentVerses.isNotEmpty) {
      currentVerseIndex = safeIndex;
      await player.seek(Duration.zero, index: safeIndex);
      notifyListeners();
      return;
    }

    isLoading = true;
    isReady = false;
    activeMode = 'quran';
    currentSurahNumber = surah.number;
    currentSurahEnglish = surah.englishName;
    currentSurahArabic = surah.name;
    currentVerses = verses;
    currentVerseIndex = safeIndex;
    notifyListeners();

    final sources = verses.map((verse) {
      final globalAyah = verse['number'];
      final verseNum = verse['numberInSurah'];
      return AudioSource.uri(
        Uri.parse(
          'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$globalAyah.mp3',
        ),
        tag: MediaItem(
          id: 'surah_${surah.number}_ayah_$verseNum',
          album: surah.englishName,
          title: '${surah.englishName} - Verse $verseNum',
          artist: 'Mishary Rashid Alafasy',
        ),
      );
    }).toList();

    await player.stop();
    await player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      preload: false,
    );
    await player.setSpeed(playbackSpeed);
    await _applyRepeatMode();
    await player.seek(Duration.zero, index: safeIndex);

    isReady = true;
    isLoading = false;
    notifyListeners();
  }

  Future<void> playSurahFromVerse(
    Surah surah,
    List<dynamic> verses,
    int index, {
    required bool repeatSingle,
  }) async {
    if (index < 0 || index >= verses.length) return;

    if (activeMode == 'quran' &&
        currentSurahNumber == surah.number &&
        isReady &&
        currentVerses.isNotEmpty) {
      await playQuranFromVerse(index, repeatSingle: repeatSingle);
      return;
    }

    isLoading = true;
    isReady = false;
    activeMode = 'quran';
    currentSurahNumber = surah.number;
    currentSurahEnglish = surah.englishName;
    currentSurahArabic = surah.name;
    currentVerses = verses;
    currentVerseIndex = index;
    repeatMode = repeatSingle ? 1 : 0;
    notifyListeners();

    final sources = verses.map((verse) {
      final globalAyah = verse['number'];
      final verseNum = verse['numberInSurah'];
      return AudioSource.uri(
        Uri.parse(
          'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$globalAyah.mp3',
        ),
        tag: MediaItem(
          id: 'surah_${surah.number}_ayah_$verseNum',
          album: surah.englishName,
          title: '${surah.englishName} - Verse $verseNum',
          artist: 'Mishary Rashid Alafasy',
        ),
      );
    }).toList();

    await player.stop();
    await player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      preload: false,
    );
    await player.setSpeed(playbackSpeed);
    await _applyRepeatMode();
    await player.seek(Duration.zero, index: index);

    isReady = true;
    isLoading = false;
    notifyListeners();

    await player.play();
    await _saveLastPlayed(
      surah.englishName,
      surah.number,
      verses[index]['numberInSurah'] as int,
    );
  }

  Future<void> playQuranFromVerse(
    int index, {
    required bool repeatSingle,
  }) async {
    if (index < 0 || index >= currentVerses.length) return;
    repeatMode = repeatSingle ? 1 : 0;
    await _applyRepeatMode();
    await player.seek(Duration.zero, index: index);
    currentVerseIndex = index;
    notifyListeners();
    if (!isPlaying) {
      await player.play();
    }
    await _saveLastPlayed(
      currentSurahEnglish,
      currentSurahNumber,
      currentVerses[index]['numberInSurah'] as int,
    );
  }

  Future<void> cycleSpeed() async {
    const speeds = [1.0, 1.25, 1.5, 1.75, 2.0, 0.75];
    final nextIdx = (speeds.indexOf(playbackSpeed) + 1) % speeds.length;
    playbackSpeed = speeds[nextIdx];
    await player.setSpeed(playbackSpeed);
    notifyListeners();
  }

  Future<void> cycleRepeatMode() async {
    repeatMode = (repeatMode + 1) % 3;
    await _applyRepeatMode();
    notifyListeners();
  }

  Future<void> _applyRepeatMode() async {
    if (repeatMode == 1) {
      await player.setLoopMode(LoopMode.one);
    } else if (repeatMode == 2) {
      await player.setLoopMode(LoopMode.all);
    } else {
      await player.setLoopMode(LoopMode.off);
    }
  }

  Future<void> _handleQuranCompleted() async {
    if (repeatMode != 0) return;

    if (currentSurahNumber < 114) {
      final nextNumber = currentSurahNumber + 1;
      final nextSurah = allSurahs.firstWhere(
        (s) => s.number == nextNumber,
        orElse: () => Surah.fromJson({
          'number': nextNumber,
          'name': 'سورة $nextNumber',
          'englishName': 'Surah $nextNumber',
          'englishNameTranslation': '',
        }),
      );
      await loadSurah(nextSurah, autoPlay: true);
    } else {
      await player.pause();
      await player.seek(Duration.zero, index: 0);
      currentVerseIndex = 0;
      notifyListeners();
    }
  }

  Future<void> _saveLastPlayed(
    String surahName,
    int surahNum,
    int verseNum,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPlayedSurah', surahName);
    await prefs.setString('lastPlayedVerse', '$surahNum:$verseNum');
    await prefs.setInt('lastPlayedSurahNumber', surahNum);
    await prefs.setInt('lastPlayedVerseNumber', verseNum);
  }

  // ==================== AZKAR METHODS ====================

  Future<void> startAzkarPlaylist({
    required String categoryTitle,
    required List<AzkarItem> azkarList,
    required int startIndex,
    required Map<int, int> currentCounters,
  }) async {
    if (azkarList.isEmpty) return;

    activeMode = 'azkar';
    activeAzkarCategory = categoryTitle;
    _azkarPlaylist = azkarList;
    _trackToAzkarIndex.clear();
    _trackRepetitionNumber.clear();
    _lastTrackedAzkarTrack = -1;

    final sources = <AudioSource>[];
    int trackCounter = 0;

    for (int i = startIndex; i < azkarList.length; i++) {
      final item = azkarList[i];
      final audioPath = item.audioUrl ?? '';
      if (audioPath.isEmpty) continue;

      final alreadyDone = currentCounters[i] ?? 0;
      final remaining = (item.targetCount - alreadyDone).clamp(
        1,
        item.targetCount,
      );

      for (int rep = 1; rep <= remaining; rep++) {
        _trackToAzkarIndex.add(i);
        _trackRepetitionNumber.add(alreadyDone + rep);

        final source = audioPath.startsWith('http')
            ? AudioSource.uri(
                Uri.parse(audioPath),
                tag: MediaItem(
                  id: '${categoryTitle}_${i}_$trackCounter',
                  album: categoryTitle,
                  title: '$categoryTitle (${i + 1}/${azkarList.length})',
                  artist: 'Hisn al-Muslim',
                ),
              )
            : AudioSource.asset(
                audioPath,
                tag: MediaItem(
                  id: '${categoryTitle}_${i}_$trackCounter',
                  album: categoryTitle,
                  title: '$categoryTitle (${i + 1}/${azkarList.length})',
                  artist: 'Hisn al-Muslim',
                ),
              );

        sources.add(source);
        trackCounter++;
      }
    }

    if (sources.isEmpty) return;

    await player.stop();
    await player.setLoopMode(LoopMode.off);
    await player.setSpeed(1.0);
    await player.setAudioSource(ConcatenatingAudioSource(children: sources));
    await player.play();

    await _onAzkarTrackReached(0);
  }

  Future<void> _onAzkarTrackReached(int trackIndex) async {
    if (trackIndex < 0 || trackIndex >= _trackToAzkarIndex.length) return;

    if (_lastTrackedAzkarTrack >= 0 &&
        _lastTrackedAzkarTrack < _trackToAzkarIndex.length &&
        trackIndex > _lastTrackedAzkarTrack) {
      final completedAzkarIdx = _trackToAzkarIndex[_lastTrackedAzkarTrack];
      final completedCount = _trackRepetitionNumber[_lastTrackedAzkarTrack];
      await _incrementAzkarCounterInPrefs(completedAzkarIdx, completedCount);
    }

    _lastTrackedAzkarTrack = trackIndex;
    currentAzkarIndex = _trackToAzkarIndex[trackIndex];
    notifyListeners();
  }

  Future<void> _incrementAzkarCounterInPrefs(int azkarIndex, int count) async {
    if (activeAzkarCategory == null) return;
    final prefs = await SharedPreferences.getInstance();
    final countersKey = '${activeAzkarCategory}_counters';
    final indexKey = '${activeAzkarCategory}_index';
    final dateKey = '${activeAzkarCategory}_date';

    final today = DateTime.now().toString().substring(0, 10);
    await prefs.setString(dateKey, today);

    Map<String, dynamic> decoded = {};
    final existing = prefs.getString(countersKey);
    if (existing != null) {
      decoded = json.decode(existing);
    }
    decoded[azkarIndex.toString()] = count;
    await prefs.setString(countersKey, json.encode(decoded));
    await prefs.setInt(indexKey, azkarIndex);
  }

  Future<void> _handleAzkarCompleted() async {
    if (_lastTrackedAzkarTrack >= 0 &&
        _lastTrackedAzkarTrack < _trackToAzkarIndex.length) {
      final finalAzkarIdx = _trackToAzkarIndex[_lastTrackedAzkarTrack];
      final finalCount = _trackRepetitionNumber[_lastTrackedAzkarTrack];
      await _incrementAzkarCounterInPrefs(finalAzkarIdx, finalCount);
    }
    _lastTrackedAzkarTrack = -1;
    isPlaying = false;
    notifyListeners();
  }

  Future<void> handleAzkarScreenExit(String categoryTitle) async {
    if (activeMode == 'azkar' &&
        activeAzkarCategory == categoryTitle &&
        !isPlaying &&
        _azkarPlaylist.isNotEmpty) {
      await player.stop();
      activeMode = 'none';
      activeAzkarCategory = null;
      _azkarPlaylist = [];
      notifyListeners();
    }
  }
}
