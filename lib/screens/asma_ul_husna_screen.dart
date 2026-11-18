import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllahNameItem {
  final int number;
  final String arabic;
  final String transliteration;
  final String meaning;

  const AllahNameItem({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
  });
}

class AsmaUlHusnaScreen extends StatefulWidget {
  const AsmaUlHusnaScreen({super.key});

  @override
  State<AsmaUlHusnaScreen> createState() => _AsmaUlHusnaScreenState();
}

class _AsmaUlHusnaScreenState extends State<AsmaUlHusnaScreen> {
  static const String _endpoint = 'https://api.aladhan.com/v1/asmaAlHusna';
  static const String _cacheKey = 'asma_ul_husna_cache_v1';

  final TextEditingController _searchController = TextEditingController();
  List<AllahNameItem> _allNames = <AllahNameItem>[];
  List<AllahNameItem> _filteredNames = <AllahNameItem>[];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _hapticsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNames() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      _hapticsEnabled = prefs.getBool('haptics_enabled') ?? true;

      String? rawBody = prefs.getString(_cacheKey);
      if (rawBody == null || rawBody.isEmpty) {
        final response = await http.get(Uri.parse(_endpoint));
        if (response.statusCode != 200) {
          throw Exception('Server returned ${response.statusCode}');
        }
        rawBody = response.body;
        await prefs.setString(_cacheKey, rawBody);
      }

      final Map<String, dynamic> decoded =
          json.decode(rawBody) as Map<String, dynamic>;
      final List<dynamic> dataList =
          (decoded['data'] as List<dynamic>?) ?? <dynamic>[];

      final List<AllahNameItem> parsed = <AllahNameItem>[];
      for (final raw in dataList) {
        final map = raw as Map<String, dynamic>;
        final enMap = (map['en'] as Map<String, dynamic>?) ?? <String, dynamic>{};
        parsed.add(
          AllahNameItem(
            number: (map['number'] as num?)?.toInt() ?? 0,
            arabic: (map['name'] ?? '').toString().trim(),
            transliteration: (map['transliteration'] ?? '').toString().trim(),
            meaning: (enMap['meaning'] ?? '').toString().trim(),
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _allNames = parsed;
        _filteredNames = parsed;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Unable to load the 99 Names of Allah. Please check your internet connection and retry.';
        _isLoading = false;
      });
    }
  }

  void _filterNames(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      setState(() => _filteredNames = _allNames);
      return;
    }

    setState(() {
      _filteredNames = _allNames.where((item) {
        return item.number.toString() == trimmed ||
            item.transliteration.toLowerCase().contains(trimmed) ||
            item.meaning.toLowerCase().contains(trimmed) ||
            item.arabic.contains(trimmed);
      }).toList();
    });
  }

  Future<void> _copyName(AllahNameItem item) async {
    if (_hapticsEnabled) {
      await HapticFeedback.selectionClick();
    }
    final text =
        '${item.number}. ${item.arabic} (${item.transliteration}) — ${item.meaning}';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF00B060),
        content: Text(
          'Copied: ${item.transliteration}',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  AllahNameItem? get _nameOfTheDay {
    if (_allNames.isEmpty) return null;
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return _allNames[dayOfYear % _allNames.length];
  }

  @override
  Widget build(BuildContext context) {
    final dailyName = _nameOfTheDay;

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
              '99 Names of Allah',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Asma-ul-Husna • Tap any card to copy',
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B060),
                      ),
                      onPressed: _loadNames,
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                if (dailyName != null && _searchController.text.isEmpty)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF00B060).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'NAME OF THE DAY',
                                style: TextStyle(
                                  color: Color(0xFF00B060),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${dailyName.number}. ${dailyName.transliteration}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dailyName.meaning,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          dailyName.arabic,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Amiri',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterNames,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search by number, name, or meaning...',
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
                                _filterNames('');
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
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: _filteredNames.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _filteredNames[index];
                      return Material(
                        color: const Color(0xFF1F2325),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _copyName(item),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF00B060,
                                    ).withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${item.number}',
                                    style: const TextStyle(
                                      color: Color(0xFF00B060),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
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
                                        item.transliteration,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.meaning,
                                        style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  item.arabic,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Amiri',
                                    fontWeight: FontWeight.bold,
                                  ),
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