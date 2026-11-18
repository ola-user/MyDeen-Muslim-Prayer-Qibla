import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrayerScreen extends StatelessWidget {
  final Map<String, dynamic> prayerData;
  final List<dynamic> monthData;
  final String nextPrayerName;
  final String nextPrayerTimeFormatted;
  final String countdownDisplay;
  final String cityName;
  final VoidCallback? onLocationTap;

  const PrayerScreen({
    super.key,
    required this.prayerData,
    required this.monthData,
    required this.nextPrayerName,
    required this.nextPrayerTimeFormatted,
    required this.countdownDisplay,
    required this.cityName,
    this.onLocationTap,
  });

  String formatTime(String time24) {
    try {
      final cleanTime = time24.split(' ')[0];
      final format24 = DateFormat("HH:mm");
      final format12 = DateFormat("h:mm a");
      return format12.format(format24.parse(cleanTime));
    } catch (e) {
      return time24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timings = prayerData['timings'];
    final dateData = prayerData['date']['hijri'];
    final hijriDateString =
        "${dateData['month']['en']} ${dateData['day']}, ${dateData['year']} AH";

    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF00B060).withValues(alpha: 0.3),
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: onLocationTap,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFF00B060),
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                cityName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (onLocationTap != null) ...[
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00B060)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF00B060)
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.verified_outlined,
                                    color: Color(0xFF00B060),
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Ad-Free',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Icon(
                              Icons.hexagon_outlined,
                              color: Colors.white70,
                              size: 24,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nextPrayerName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nextPrayerTimeFormatted,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Next prayer in $countdownDisplay',
                    style: const TextStyle(
                      color: Color(0xFF00B060),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF141718),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2325),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
                      Text(
                        hijriDateString,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2325),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PrayerRow(
                    name: 'Fajr',
                    formattedTime: formatTime(timings['Fajr']),
                    icon: Icons.nightlight_round,
                    iconColor: const Color(0xFF00B060),
                    isCurrent: nextPrayerName == 'Fajr',
                  ),
                  PrayerRow(
                    name: 'Sunrise',
                    formattedTime: formatTime(timings['Sunrise']),
                    icon: Icons.wb_twilight,
                    iconColor: const Color(0xFF00B060),
                    isCurrent: false,
                  ),
                  PrayerRow(
                    name: 'Dhuhr',
                    formattedTime: formatTime(timings['Dhuhr']),
                    icon: Icons.wb_sunny,
                    iconColor: Colors.tealAccent,
                    isCurrent: nextPrayerName == 'Dhuhr',
                  ),
                  PrayerRow(
                    name: 'Asr',
                    formattedTime: formatTime(timings['Asr']),
                    icon: Icons.sunny,
                    iconColor: Colors.lightBlueAccent,
                    isCurrent: nextPrayerName == 'Asr',
                  ),
                  PrayerRow(
                    name: 'Maghrib',
                    formattedTime: formatTime(timings['Maghrib']),
                    icon: Icons.wb_twilight,
                    iconColor: Colors.orangeAccent,
                    isCurrent: nextPrayerName == 'Maghrib',
                  ),
                  PrayerRow(
                    name: 'Isha',
                    formattedTime: formatTime(timings['Isha']),
                    icon: Icons.nights_stay,
                    iconColor: Colors.indigoAccent,
                    isCurrent: nextPrayerName == 'Isha',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerRow extends StatefulWidget {
  final String name;
  final String formattedTime;
  final IconData icon;
  final Color iconColor;
  final bool isCurrent;

  const PrayerRow({
    super.key,
    required this.name,
    required this.formattedTime,
    required this.icon,
    required this.iconColor,
    required this.isCurrent,
  });

  @override
  State<PrayerRow> createState() => _PrayerRowState();
}

class _PrayerRowState extends State<PrayerRow> {
  bool _isCompleted = false;

  void _toggleTracker() {
    setState(() {
      _isCompleted = !_isCompleted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCompleted
              ? '${widget.name} marked as completed 🤲'
              : '${widget.name} unchecked',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: widget.isCurrent
            ? const Color(0xFF162A1D)
            : const Color(0xFF1F2325),
        borderRadius: BorderRadius.circular(16),
        border: widget.isCurrent
            ? Border.all(
                color: const Color(0xFF00B060).withValues(alpha: 0.45),
                width: 1.5,
              )
            : null,
      ),
      child: Row(
        children: [
          Icon(widget.icon, color: widget.iconColor, size: 22),
          const SizedBox(width: 12),
          Text(
            widget.name,
            style: TextStyle(
              color: widget.isCurrent ? const Color(0xFF00B060) : Colors.white,
              fontSize: 16,
              fontWeight: widget.isCurrent
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            widget.formattedTime,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _toggleTracker,
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isCompleted
                    ? const Color(0xFF00B060)
                    : Colors.transparent,
                border: Border.all(
                  color: _isCompleted
                      ? const Color(0xFF00B060)
                      : Colors.grey.shade600,
                  width: 2,
                ),
              ),
              child: _isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
