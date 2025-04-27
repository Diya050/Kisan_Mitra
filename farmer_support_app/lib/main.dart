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
  if (!await AwesomeNotifications().isNotificationAllowed()) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  try {
    NotificationService.initialize();
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(
      const Duration(hours: 6),
      0,
      BackgroundService.checkWeatherAndNotify,
      wakeup: true,
      rescheduleOnReboot: true,
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
