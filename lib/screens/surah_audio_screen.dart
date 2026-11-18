import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/surah.dart';

class SurahAudioScreen extends StatefulWidget {
  final Surah surah;

  const SurahAudioScreen({super.key, required this.surah});

  @override
  State<SurahAudioScreen> createState() => _SurahAudioScreenState();
}

class _SurahAudioScreenState extends State<SurahAudioScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      // 1. Listen to player state changes BEFORE setting the URL
      _audioPlayer.playerStateStream.listen((playerState) {
        final isPlaying = playerState.playing;
        final processingState = playerState.processingState;

        setState(() {
          _isPlaying = isPlaying;
          // 2. Correctly handle BOTH loading and buffering states
          _isLoading =
              (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering);
        });

        // 3. Reset the audio when it finishes so it can be played again
        if (processingState == ProcessingState.completed) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
        }
      });

      // 4. Catch any network drop/stream errors so the app doesn't freeze
      _audioPlayer.playbackEventStream.listen(
        (event) {},
        onError: (Object e, StackTrace stackTrace) {
          debugPrint('Audio stream error: $e');
          setState(() {
            _isLoading = false;
            _isPlaying = false;
          });
        },
      );

      // 5. Now load the URL
      final url =
          'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/${widget.surah.number}.mp3';
      await _audioPlayer.setUrl(url);
    } catch (e) {
      debugPrint("Error loading audio: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(widget.surah.englishName),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.surah.name, // Arabic text
              style: const TextStyle(
                fontSize: 48,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.surah.englishNameTranslation,
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 50),

            // Play/Pause Button
            _isLoading
                ? const CircularProgressIndicator(color: Colors.green)
                : IconButton(
                    iconSize: 80,
                    color: Colors.green,
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                    ),
                    onPressed: () {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
