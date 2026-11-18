import 'dart:convert';

import 'package:http/http.dart' as http;

class QuranService {
  // 1. Fetches the list of all 114 Surahs
  Future<List<dynamic>> getAllSurahs() async {
    const url = 'http://api.alquran.cloud/v1/surah';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return decodedData['data'];
      } else {
        throw Exception('Failed to load Surahs');
      }
    } catch (e) {
      throw Exception('Error fetching Quran data: $e');
    }
  }

  // 2. NEW: Fetches the Arabic text AND English translation for a specific Surah
  Future<List<dynamic>> getSurahDetails(int surahNumber) async {
    // This URL requests both 'quran-uthmani' (Arabic) and 'en.sahih' (English)
    final url =
        'http://api.alquran.cloud/v1/surah/$surahNumber/editions/quran-uthmani,en.sahih';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        // This returns an array with two items: [0] is Arabic, [1] is English
        return decodedData['data'];
      } else {
        throw Exception('Failed to load Surah verses');
      }
    } catch (e) {
      throw Exception('Error fetching verses: $e');
    }
  }
}
