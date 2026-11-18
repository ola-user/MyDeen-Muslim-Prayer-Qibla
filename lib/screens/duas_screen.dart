import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DuaSession {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<PropheticDua> duas;

  const DuaSession({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.duas,
  });
}

class PropheticDua {
  final String title;
  final String arabic;
  final String latin;
  final String translation;
  final String notes;
  final String fawaid;
  final String source;
  final int targetCount;

  const PropheticDua({
    required this.title,
    required this.arabic,
    required this.latin,
    required this.translation,
    required this.notes,
    required this.fawaid,
    required this.source,
    required this.targetCount,
  });
}

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DuaSession> _allSessions = <DuaSession>[];
  List<DuaSession> _filteredSessions = <DuaSession>[];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDuaSessions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _extractTargetCount(String notes) {
    final match = RegExp(
      r'(\d+)\s*(?:x|times|time)',
      caseSensitive: false,
    ).firstMatch(notes);
    if (match != null) {
      final parsed = int.tryParse(match.group(1) ?? '');
      if (parsed != null && parsed > 0) return parsed;
    }
    return 1;
  }

  String _formatSessionTitle(String slug) {
    switch (slug.toLowerCase()) {
      case 'daily-dua':
        return 'Daily & Situational Du\'as';
      case 'selected-dua':
        return 'Selected Prophetic Du\'as';
      case 'after-salah':
        return 'After Obligatory Salah';
      case 'morning':
        return 'Morning Supplications';
      case 'evening':
        return 'Evening Supplications';
      case 'before-sleep':
      case 'sleep':
        return 'Before Sleep & Night';
      case 'waking-up':
        return 'Waking Up & Tahajjud';
      default:
        return slug
            .split(RegExp(r'[-_]'))
            .where((w) => w.isNotEmpty)
            .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
            .join(' ');
    }
  }

  String _formatSessionSubtitle(String slug, int count) {
    final lower = slug.toLowerCase();
    if (lower.contains('daily')) {
      return '$count authentic Du\'as for distress, guidance, travel & daily needs';
    }
    if (lower.contains('selected')) {
      return '$count comprehensive supplications from Quran & Sunnah';
    }
    if (lower.contains('salah')) {
      return '$count Sunnah remembrances right after Tasleem';
    }
    if (lower.contains('morning')) {
      return '$count authentic morning protections & blessings';
    }
    if (lower.contains('evening')) {
      return '$count authentic evening protections & tranquility';
    }
    return '$count authentic supplications with virtues & references';
  }

  IconData _iconForSession(String slug) {
    final lower = slug.toLowerCase();
    if (lower.contains('morning')) return Icons.wb_sunny_outlined;
    if (lower.contains('evening') || lower.contains('night')) {
      return Icons.nights_stay_outlined;
    }
    if (lower.contains('salah')) return Icons.mosque_outlined;
    if (lower.contains('selected')) return Icons.auto_awesome_outlined;
    return Icons.volunteer_activism_outlined;
  }

  Future<void> _loadDuaSessions() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assetPaths =
          manifest
              .listAssets()
              .where(
                (path) =>
                    path.startsWith('assets/data/duas/') &&
                    path.endsWith('.json'),
              )
              .toList()
            ..sort();

      if (assetPaths.isEmpty) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'No Du\'a session files found in assets/data/duas/.\nRun the PowerShell download script and restart the app.';
          _isLoading = false;
        });
        return;
      }

      final List<DuaSession> sessions = <DuaSession>[];

      for (final path in assetPaths) {
        final raw = await rootBundle.loadString(path);
        final dynamic decoded = json.decode(raw);
        if (decoded is! List) continue;

        final fileName = path.split('/').last;
        final slug = fileName.replaceAll('.json', '');

        final List<PropheticDua> duas = <PropheticDua>[];
        for (final item in decoded) {
          if (item is! Map) continue;
          final map = Map<String, dynamic>.from(item);
          final notes = (map['notes'] ?? '').toString().trim();

          duas.add(
            PropheticDua(
              title: (map['title'] ?? 'Supplication').toString().trim(),
              arabic: (map['arabic'] ?? '').toString().trim(),
              latin: (map['latin'] ?? '').toString().trim(),
              translation: (map['translation'] ?? '').toString().trim(),
              notes: notes,
              fawaid: (map['fawaid'] ?? '').toString().trim(),
              source: (map['source'] ?? '').toString().trim(),
              targetCount: _extractTargetCount(notes),
            ),
          );
        }

        if (duas.isNotEmpty) {
          sessions.add(
            DuaSession(
              id: slug,
              title: _formatSessionTitle(slug),
              subtitle: _formatSessionSubtitle(slug, duas.length),
              icon: _iconForSession(slug),
              duas: duas,
            ),
          );
        }
      }

      // Prioritize situational/selected Du'a sessions at the top
      sessions.sort((a, b) {
        int rank(String id) {
          if (id.contains('daily')) return 0;
          if (id.contains('selected')) return 1;
          if (id.contains('salah')) return 2;
          if (id.contains('morning')) return 3;
          if (id.contains('evening')) return 4;
          return 5;
        }

        return rank(a.id).compareTo(rank(b.id));
      });

      if (!mounted) return;
      setState(() {
        _allSessions = sessions;
        _filteredSessions = sessions;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Could not load Du\'a sessions.\n\nDetails: $e';
        _isLoading = false;
      });
    }
  }

  void _filterSessions(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      setState(() => _filteredSessions = _allSessions);
      return;
    }

    setState(() {
      _filteredSessions = _allSessions
          .map((session) {
            final sessionMatches =
                session.title.toLowerCase().contains(trimmed) ||
                session.subtitle.toLowerCase().contains(trimmed);
            if (sessionMatches) return session;

            final matchingDuas = session.duas.where((dua) {
              return dua.title.toLowerCase().contains(trimmed) ||
                  dua.translation.toLowerCase().contains(trimmed) ||
                  dua.fawaid.toLowerCase().contains(trimmed) ||
                  dua.latin.toLowerCase().contains(trimmed);
            }).toList();

            if (matchingDuas.isEmpty) return null;
            return DuaSession(
              id: session.id,
              title: session.title,
              subtitle: '${matchingDuas.length} matching supplications',
              icon: session.icon,
              duas: matchingDuas,
            );
          })
          .whereType<DuaSession>()
          .toList();
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
              'Prophetic Du\'as',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Authentic Supplications, Virtues & Sessions',
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
                    onChanged: _filterSessions,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search Du\'a by need (e.g. Forgiveness, Distress, Sleep)...',
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
                                _filterSessions('');
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
                    itemCount: _filteredSessions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final session = _filteredSessions[index];
                      return Material(
                        color: const Color(0xFF1F2325),
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DuaSessionDetailScreen(session: session),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00B060)
                                        .withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    session.icon,
                                    color: const Color(0xFF00B060),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        session.subtitle,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
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

class DuaSessionDetailScreen extends StatefulWidget {
  final DuaSession session;

  const DuaSessionDetailScreen({super.key, required this.session});

  @override
  State<DuaSessionDetailScreen> createState() => _DuaSessionDetailScreenState();
}

class _DuaSessionDetailScreenState extends State<DuaSessionDetailScreen> {
  final Map<int, int> _counts = <int, int>{};
  double _arabicFontSize = 26.0;
  bool _showTransliteration = true;
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
      _showTransliteration = prefs.getBool('show_transliteration') ?? true;
      _showTranslation = prefs.getBool('show_translation') ?? true;
      _hapticsEnabled = prefs.getBool('haptics_enabled') ?? true;
    });
  }

  Future<void> _increment(int index, int target) async {
    final current = _counts[index] ?? 0;
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
      _counts[index] = next;
    });
  }

  Future<void> _copyDua(PropheticDua dua) async {
    if (_hapticsEnabled) {
      await HapticFeedback.selectionClick();
    }
    final buffer = StringBuffer()
      ..writeln(dua.title)
      ..writeln()
      ..writeln(dua.arabic);
    if (dua.latin.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(dua.latin);
    }
    if (dua.translation.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln(dua.translation);
    }
    if (dua.source.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Reference: ${dua.source}');
    }
    buffer.write('— Shared from MyDeen: Muslim Prayer & Qibla');

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF00B060),
        content: Text(
          'Du\'a copied to clipboard!',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ),
    );
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
          widget.session.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.session.duas.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final dua = widget.session.duas[index];
          final currentCount = _counts[index] ?? 0;
          final isComplete = currentCount >= dua.targetCount;

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        dua.title,
                        style: const TextStyle(
                          color: Color(0xFF00B060),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Copy Du\'a',
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: Colors.white54,
                        size: 18,
                      ),
                      onPressed: () => _copyDua(dua),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  dua.arabic,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _arabicFontSize,
                    height: 1.85,
                    fontFamily: 'Amiri',
                  ),
                ),
                if (_showTransliteration && dua.latin.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    dua.latin,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ],
                if (_showTranslation && dua.translation.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFF2B3033), height: 1),
                  const SizedBox(height: 12),
                  Text(
                    dua.translation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.55,
                    ),
                  ),
                ],
                if (dua.fawaid.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B060).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00B060).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: Color(0xFF00B060),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Virtue & Reward',
                              style: TextStyle(
                                color: Color(0xFF00B060),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dua.fawaid,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (dua.notes.isNotEmpty || dua.source.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  if (dua.notes.isNotEmpty)
                    Text(
                      dua.notes,
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  if (dua.source.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Source: ${dua.source}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target: ${dua.targetCount}x',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _increment(index, dua.targetCount),
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
                              ? 'Completed ($currentCount/${dua.targetCount})'
                              : 'Recite $currentCount / ${dua.targetCount}',
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
