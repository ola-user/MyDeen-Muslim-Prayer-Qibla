import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HijriDayEntry {
  final int gregorianDay;
  final String gregorianDate;
  final String weekdayShort;
  final String hijriDay;
  final String hijriMonthEn;
  final String hijriMonthAr;
  final String hijriYear;
  final List<String> holidays;

  const HijriDayEntry({
    required this.gregorianDay,
    required this.gregorianDate,
    required this.weekdayShort,
    required this.hijriDay,
    required this.hijriMonthEn,
    required this.hijriMonthAr,
    required this.hijriYear,
    required this.holidays,
  });
}

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  late DateTime _focusedMonth;
  List<HijriDayEntry> _days = <HijriDayEntry>[];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
    _loadMonthCalendar();
  }

  Future<void> _loadMonthCalendar() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final month = _focusedMonth.month;
    final year = _focusedMonth.year;
    final cacheKey = 'hijri_cal_${year}_${month}_v1';

    try {
      final prefs = await SharedPreferences.getInstance();
      String? rawBody = prefs.getString(cacheKey);

      if (rawBody == null || rawBody.isEmpty) {
        final url = 'https://api.aladhan.com/v1/gToHCalendar/$month/$year';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 200) {
          throw Exception('Server returned ${response.statusCode}');
        }
        rawBody = response.body;
        await prefs.setString(cacheKey, rawBody);
      }

      final Map<String, dynamic> decoded =
          json.decode(rawBody) as Map<String, dynamic>;
      final List<dynamic> dataList =
          (decoded['data'] as List<dynamic>?) ?? <dynamic>[];

      final List<HijriDayEntry> parsed = <HijriDayEntry>[];
      for (final raw in dataList) {
        final map = raw as Map<String, dynamic>;
        final greg = map['gregorian'] as Map<String, dynamic>;
        final hijri = map['hijri'] as Map<String, dynamic>;
        final gregWeekday = greg['weekday'] as Map<String, dynamic>;
        final hijriMonth = hijri['month'] as Map<String, dynamic>;

        final List<String> holidayList = <String>[];
        final rawHolidays = hijri['holidays'];
        if (rawHolidays is List) {
          for (final h in rawHolidays) {
            final text = h.toString().trim();
            if (text.isNotEmpty) holidayList.add(text);
          }
        }

        parsed.add(
          HijriDayEntry(
            gregorianDay:
                int.tryParse((greg['day'] ?? '1').toString()) ?? 1,
            gregorianDate: (greg['date'] ?? '').toString(),
            weekdayShort: (gregWeekday['en'] ?? '').toString(),
            hijriDay: (hijri['day'] ?? '').toString(),
            hijriMonthEn: (hijriMonth['en'] ?? '').toString(),
            hijriMonthAr: (hijriMonth['ar'] ?? '').toString(),
            hijriYear: (hijri['year'] ?? '').toString(),
            holidays: holidayList,
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _days = parsed;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Could not load Hijri calendar. Check your internet connection and try again.';
        _isLoading = false;
      });
    }
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + delta,
        1,
      );
    });
    _loadMonthCalendar();
  }

  int _leadingEmptyCells() {
    if (_days.isEmpty) return 0;
    final firstWeekday = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    ).weekday;
    return firstWeekday % 7;
  }

  HijriDayEntry? get _todayEntry {
    if (_days.isEmpty) return null;
    final now = DateTime.now();
    if (now.year == _focusedMonth.year && now.month == _focusedMonth.month) {
      for (final d in _days) {
        if (d.gregorianDay == now.day) return d;
      }
    }
    return _days.first;
  }

  String get _hijriHeaderSpan {
    if (_days.isEmpty) return '';
    final first = _days.first;
    final last = _days.last;
    if (first.hijriMonthEn == last.hijriMonthEn) {
      return '${first.hijriMonthEn} ${first.hijriYear} AH';
    }
    return '${first.hijriMonthEn} / ${last.hijriMonthEn} ${last.hijriYear} AH';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isCurrentMonth =
        now.year == _focusedMonth.year && now.month == _focusedMonth.month;
    final highlightDay = _todayEntry;
    final holidayDays =
        _days.where((d) => d.holidays.isNotEmpty).toList();
    final leadingBlanks = _leadingEmptyCells();

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
              'Hijri Calendar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Islamic Lunar Dates & Special Days',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          if (!isCurrentMonth)
            TextButton(
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(now.year, now.month, 1);
                });
                _loadMonthCalendar();
              },
              child: const Text(
                'Today',
                style: TextStyle(
                  color: Color(0xFF00B060),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
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
                      onPressed: _loadMonthCalendar,
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (highlightDay != null)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                              Text(
                                isCurrentMonth
                                    ? 'TODAY\'S HIJRI DATE'
                                    : 'MONTH START HIJRI DATE',
                                style: const TextStyle(
                                  color: Color(0xFF00B060),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${highlightDay.hijriDay} ${highlightDay.hijriMonthEn} ${highlightDay.hijriYear} AH',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${highlightDay.weekdayShort}, ${highlightDay.gregorianDate}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          highlightDay.hijriMonthAr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontFamily: 'Amiri',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2325),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => _changeMonth(-1),
                          ),
                          Column(
                            children: [
                              Text(
                                DateFormat('MMMM yyyy').format(_focusedMonth),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _hijriHeaderSpan,
                                style: const TextStyle(
                                  color: Color(0xFF00B060),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => _changeMonth(1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                            .map(
                              (dayName) => Expanded(
                                child: Center(
                                  child: Text(
                                    dayName,
                                    style: TextStyle(
                                      color: dayName == 'Fri'
                                          ? const Color(0xFF00B060)
                                          : Colors.white54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: leadingBlanks + _days.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 0.88,
                        ),
                        itemBuilder: (context, index) {
                          if (index < leadingBlanks) {
                            return const SizedBox.shrink();
                          }
                          final day = _days[index - leadingBlanks];
                          final isToday =
                              isCurrentMonth && day.gregorianDay == now.day;
                          final hasHoliday = day.holidays.isNotEmpty;

                          return Container(
                            decoration: BoxDecoration(
                              color: isToday
                                  ? const Color(0xFF00B060)
                                  : hasHoliday
                                      ? const Color(0xFF00B060)
                                          .withValues(alpha: 0.18)
                                      : const Color(0xFF141718),
                              borderRadius: BorderRadius.circular(10),
                              border: hasHoliday && !isToday
                                  ? Border.all(
                                      color: const Color(0xFF00B060)
                                          .withValues(alpha: 0.5),
                                    )
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${day.gregorianDay}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: isToday
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  day.hijriDay,
                                  style: TextStyle(
                                    color: isToday
                                        ? Colors.white
                                        : const Color(0xFF00B060),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (holidayDays.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'ISLAMIC EVENTS THIS MONTH',
                      style: TextStyle(
                        color: Color(0xFF00B060),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  ...holidayDays.map(
                    (d) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2325),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00B060)
                                  .withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${d.hijriDay} ${d.hijriMonthEn}',
                              style: const TextStyle(
                                color: Color(0xFF00B060),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              d.holidays.join(' • '),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}