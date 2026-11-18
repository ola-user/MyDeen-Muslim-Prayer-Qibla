import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );
    await _notificationsPlugin.initialize(settings: initSettings);
  }

  static Future<void> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  // LOOPS THROUGH THE REST OF THE MONTH AND SCHEDULES ALARMS
  static Future<void> scheduleMonthlyPrayerAlarms(
    int baseId,
    String prayerName,
    List<dynamic> monthData,
  ) async {
    final now = DateTime.now();

    // Loop from today to the end of the month
    for (int i = now.day - 1; i < monthData.length; i++) {
      final dayData = monthData[i];

      final rawTime = dayData['timings'][prayerName].toString().split(' ')[0];
      final timeParts = rawTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final dateString = dayData['date']['gregorian']['date'];
      final dateParts = dateString.split('-');
      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);

      final alarmTime = DateTime(year, month, day, hour, minute);

      // Only schedule if the time hasn't passed yet
      if (alarmTime.isAfter(now)) {
        // Create a unique ID for this day (e.g. Fajr ID 1 + Day 15 = ID 115)
        final uniqueId = (baseId * 100) + day;

        await _notificationsPlugin.zonedSchedule(
          id: uniqueId,
          title: 'Time for $prayerName',
          body: 'It is time to pray $prayerName',
          scheduledDate: tz.TZDateTime.from(alarmTime, tz.local),
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_channel_id',
              'Prayer Alarms',
              channelDescription: 'Notifications for daily prayers',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }

  // CANCELS EVERY ALARM FOR THIS PRAYER THIS MONTH
  static Future<void> cancelMonthlyAlarms(int baseId) async {
    for (int i = 1; i <= 31; i++) {
      await _notificationsPlugin.cancel(id: (baseId * 100) + i);
    }
  }

  // --- NEW: AUTO-SCHEDULE EVERYTHING ---
  static Future<void> autoScheduleAllMonth(List<dynamic> monthData) async {
    // We skip Sunrise (ID 2) so it doesn't wake the user up, only mandatory prayers
    await scheduleMonthlyPrayerAlarms(1, 'Fajr', monthData);
    await scheduleMonthlyPrayerAlarms(3, 'Dhuhr', monthData);
    await scheduleMonthlyPrayerAlarms(4, 'Asr', monthData);
    await scheduleMonthlyPrayerAlarms(5, 'Maghrib', monthData);
    await scheduleMonthlyPrayerAlarms(6, 'Isha', monthData);
  }
}
