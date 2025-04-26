// import 'package:farmer_support_app/screens/login_screen.dart';
import 'package:farmer_support_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/localization_provider.dart';
// import 'screens/home_page.dart';

void main() {
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: localization.translate('KisanMitra'),
      locale: localization.locale,
      supportedLocales: const [Locale('en'), Locale('hi')],
      home: SplashScreen(), // Updated to HomePage with navbar
    );
  }
}
