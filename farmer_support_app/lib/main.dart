// lib/main.dart
import 'package:farmer_support_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/localization_provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'services/background_service.dart';
import '/services/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  if (!await AwesomeNotifications().isNotificationAllowed()) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  try {
    NotificationService.initialize();
    await AndroidAlarmManager.periodic(
      const Duration(
          minutes:
              30), // interval ≥ 15 min :contentReference[oaicite:6]{index=6}
      1, // unique alarm ID
      BackgroundService.checkWeatherAndNotify,
      exact: true, // exact timing :contentReference[oaicite:7]{index=7}
      wakeup:
          true, // wake device from Doze :contentReference[oaicite:8]{index=8}
      allowWhileIdle:
          true, // run even in idle/doze :contentReference[oaicite:9]{index=9}
      rescheduleOnReboot:
          true, // re-register after reboot :contentReference[oaicite:10]{index=10}
    );
  } catch (e) {
    print('Initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: localization.translate('KisanMitra'),
      locale: localization.locale,
      supportedLocales: const [Locale('en'), Locale('hi')],
      home: SplashScreen(),
    );
  }
}
