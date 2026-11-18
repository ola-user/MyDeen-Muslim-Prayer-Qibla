import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/azkar_item.dart';
import '../services/global_audio_service.dart';

class AzkarReadingScreen extends StatefulWidget {
  final String categoryTitle;
  final List<AzkarItem> azkarList;

  const AzkarReadingScreen({
    super.key,
    required this.categoryTitle,
    required this.azkarList,
  });

  @override
  State<AzkarReadingScreen> createState() => _AzkarReadingScreenState();
}

class _AzkarReadingScreenState extends State<AzkarReadingScreen> {
  final GlobalAudioService _audio = GlobalAudioService.instance;
  PageController? _pageController;

  int _currentIndex = 0;
  Map<int, int> _counters = {};
  bool _isLoading = true;
  bool _isProgrammaticPageChange = false;

  String get _today => DateTime.now().toString().substring(0, 10);
  String get _dateKey => '${widget.categoryTitle}_date';
  String get _indexKey => '${widget.categoryTitle}_index';
  String get _countersKey => '${widget.categoryTitle}_counters';

  bool get _isThisCategoryPlaying =>
      _audio.activeMode == 'azkar' &&
      _audio.activeAzkarCategory == widget.categoryTitle &&
      _audio.isPlaying;

  @override
  void initState() {
    super.initState();
    _audio.addListener(_onAudioChanged);
    _initMemory();
  }

  @override
  void dispose() {
    _audio.removeListener(_onAudioChanged);
    _audio.handleAzkarScreenExit(widget.categoryTitle);
    _pageController?.dispose();
    super.dispose();
  }

  void _onAudioChanged() {
    if (!mounted) return;
    if (_audio.activeMode == 'azkar' &&
        _audio.activeAzkarCategory == widget.categoryTitle) {
      _reloadCountersFromPrefs();
      final target = _audio.currentAzkarIndex;
      if (target != _currentIndex &&
          target < widget.azkarList.length &&
          _pageController != null &&
          _pageController!.hasClients) {
        _isProgrammaticPageChange = true;
        _currentIndex = target;
        _pageController!
            .animateToPage(
              target,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
            .then((_) => _isProgrammaticPageChange = false);
      }
    }
    setState(() {});
  }

  Future<void> _reloadCountersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final countersString = prefs.getString(_countersKey);
    if (countersString != null && mounted) {
      final Map<String, dynamic> decoded = json.decode(countersString);
      setState(() {
        _counters = decoded.map(
          (key, value) => MapEntry(int.parse(key), value as int),
        );
      });
    }
  }

  Future<void> _toggleAudio() async {
    if (_isThisCategoryPlaying) {
      await _audio.player.pause();
    } else {
      await _audio.startAzkarPlaylist(
        categoryTitle: widget.categoryTitle,
        azkarList: widget.azkarList,
        startIndex: _currentIndex,
        currentCounters: _counters,
      );
    }
  }

  Future<void> _initMemory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(_dateKey);

    if (savedDate == _today) {
      _currentIndex = prefs.getInt(_indexKey) ?? 0;
      final countersString = prefs.getString(_countersKey);
      if (countersString != null) {
        final Map<String, dynamic> decoded = json.decode(countersString);
        _counters = decoded.map(
          (key, value) => MapEntry(int.parse(key), value as int),
        );
      }
    } else {
      await prefs.setString(_dateKey, _today);
      await prefs.setInt(_indexKey, 0);
      await prefs.setString(_countersKey, json.encode({}));
    }

    _pageController = PageController(initialPage: _currentIndex);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_indexKey, _currentIndex);
    final encodedCounters = json.encode(
      _counters.map((key, value) => MapEntry(key.toString(), value)),
    );
    await prefs.setString(_countersKey, encodedCounters);
  }

  void _incrementCounter(int target) {
    if (!mounted) return;
    final current = _counters[_currentIndex] ?? 0;
    if (current >= target) return;

    final isFinishing = current + 1 == target;
    if (isFinishing) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.mediumImpact();
    }

    setState(() {
      _counters[_currentIndex] = current + 1;
      _saveProgress();

      if (isFinishing) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!mounted) return;
          _nextPage();
        });
      }
    });
  }

  void _nextPage() {
    if (!mounted) return;
    if (_currentIndex < widget.azkarList.length - 1) {
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _audio.player.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Alhamdulillah, you have completed this Azkar.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF00B060),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _pageController?.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.azkarList.isEmpty || _isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            widget.categoryTitle,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    final currentAzkar = widget.azkarList[_currentIndex];
    final currentCount = _counters[_currentIndex] ?? 0;
    final isComplete = currentCount >= currentAzkar.targetCount;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.categoryTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_currentIndex + 1} / ${widget.azkarList.length}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: const Icon(
                Icons.wifi_protected_setup,
                size: 300,
                color: Colors.white,
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _saveProgress();

              if (!_isProgrammaticPageChange && _isThisCategoryPlaying) {
                _audio.startAzkarPlaylist(
                  categoryTitle: widget.categoryTitle,
                  azkarList: widget.azkarList,
                  startIndex: index,
                  currentCounters: _counters,
                );
              }
            },
            itemCount: widget.azkarList.length,
            itemBuilder: (context, index) {
              final item = widget.azkarList[index];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.arabic,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        height: 1.8,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (item.transliteration.isNotEmpty) ...[
                      Text(
                        item.transliteration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    Text(
                      item.translation,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'From: ${item.reference}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.skip_previous_outlined,
                      color: _currentIndex > 0
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      size: 30,
                    ),
                    onPressed: _prevPage,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      _isThisCategoryPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.greenAccent,
                      size: 35,
                    ),
                    onPressed: _toggleAudio,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      Icons.skip_next_outlined,
                      color: _currentIndex < widget.azkarList.length - 1
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      size: 30,
                    ),
                    onPressed: _nextPage,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _incrementCounter(currentAzkar.targetCount),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: isComplete
                        ? const Color(0xFF007A43)
                        : const Color(0xFF00B060),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$currentCount/${currentAzkar.targetCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
