import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/surah.dart';

class ApiService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  // Fetch all 114 Surahs
  Future<List<Surah>> getSurahs() async {
    final response = await http.get(Uri.parse('$baseUrl/surah'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> surahsJson = data['data'] as List<dynamic>;
      return surahsJson
          .map((json) => Surah.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load Surahs');
    }
  }

  // Fetch Arabic + English verses with Mushaf page, Juz, and Hizb metadata
  Future<List<Map<String, dynamic>>> getSurahVerses(int surahNumber) async {
    final response = await http.get(
      Uri.parse('$baseUrl/surah/$surahNumber/editions/quran-uthmani,en.sahih'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> editions = data['data'] as List<dynamic>;

      if (editions.length < 2) {
        throw Exception('Invalid verses response');
      }

      final List<dynamic> arabicAyahs = editions[0]['ayahs'] as List<dynamic>;
      final List<dynamic> englishAyahs = editions[1]['ayahs'] as List<dynamic>;

      final List<Map<String, dynamic>> verses = [];
      for (int i = 0; i < arabicAyahs.length; i++) {
        final Map<String, dynamic> arabicAyah =
            arabicAyahs[i] as Map<String, dynamic>;
        final Map<String, dynamic> englishAyah =
            englishAyahs[i] as Map<String, dynamic>;
        final int hizbQuarter = (arabicAyah['hizbQuarter'] as int?) ?? 1;

        verses.add({
          'number': arabicAyah['number'],
          'numberInSurah': arabicAyah['numberInSurah'],
          'arabic': arabicAyah['text'],
          'english': englishAyah['text'],
          'page': (arabicAyah['page'] as int?) ?? 1,
          'juz': (arabicAyah['juz'] as int?) ?? 1,
          'hizb': ((hizbQuarter - 1) ~/ 4) + 1,
        });
      }
      return verses;
    } else {
      throw Exception('Failed to load verses');
    }
  }

  // Search verses across the entire Quran by Arabic or English keyword
  Future<List<Map<String, dynamic>>> searchVerses(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.length < 2) return [];

    final bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(cleanQuery);
    final String edition = isArabic ? 'quran-simple-clean' : 'en.sahih';
    final String encodedQuery = Uri.encodeComponent(cleanQuery);

    final response = await http.get(
      Uri.parse('$baseUrl/search/$encodedQuery/all/$edition'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded =
          json.decode(response.body) as Map<String, dynamic>;
      final dynamic data = decoded['data'];
      if (data is Map<String, dynamic> && data['matches'] is List) {
        final List<dynamic> matches = data['matches'] as List<dynamic>;
        return matches.take(30).map((item) {
          final Map<String, dynamic> match = item as Map<String, dynamic>;
          final Map<String, dynamic> surah =
              match['surah'] as Map<String, dynamic>;
          return {
            'surahNumber': surah['number'] as int,
            'surahName': surah['name'] as String,
            'surahEnglishName': surah['englishName'] as String,
            'surahTranslation':
                (surah['englishNameTranslation'] as String?) ?? '',
            'numberInSurah': match['numberInSurah'] as int,
            'text': match['text'] as String,
            'isArabic': isArabic,
          };
        }).toList();
      }
    }
    return [];
  }
}
