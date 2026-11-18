import 'package:flutter/material.dart';

import '../services/quran_service.dart';

class SurahReaderScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahReaderScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  final QuranService _quranService = QuranService();
  List<dynamic> _arabicVerses = [];
  List<dynamic> _englishVerses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSurah();
  }

  Future<void> _fetchSurah() async {
    try {
      final data = await _quranService.getSurahDetails(widget.surahNumber);
      if (!mounted) return;
      setState(() {
        _arabicVerses = data[0]['ayahs']; // Arabic array
        _englishVerses = data[1]['ayahs']; // English array
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Text(
          widget.surahName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(
            context,
          ), // Fact-checked: onPressed is correct here!
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _errorMessage.isNotEmpty
          ? Center(
              child: Text(
                'Error: $_errorMessage',
                style: const TextStyle(color: Colors.redAccent),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _arabicVerses.length,
              itemBuilder: (context, index) {
                final arabicText = _arabicVerses[index]['text'];
                final englishText = _englishVerses[index]['text'];
                final verseNumber = _arabicVerses[index]['numberInSurah'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top bar: Verse number and Play Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF1E2E22),
                              radius: 16,
                              child: Text(
                                verseNumber.toString(),
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(
                                  Icons.share,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                                SizedBox(width: 16),
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.greenAccent,
                                  size: 24,
                                ), // Audio placeholder for later
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Arabic Verse (Aligned Right)
                      Text(
                        arabicText,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // English Translation (Aligned Left)
                      Text(
                        englishText,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white12),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
