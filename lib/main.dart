import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'screens/dashboard_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.muslimapp.audio.channel',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
  );

  await NotificationService.init();
  await NotificationService.requestPermission();

  runApp(const MuslimApp());
}

class MuslimApp extends StatelessWidget {
  const MuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDeen: Muslim Prayer & Qibla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.green,
      ),
      home: const DashboardScreen(),
    );
  }
}
