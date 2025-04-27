import 'package:farmer_support_app/screens/welcome_screen.dart';
import 'package:farmer_support_app/screens/home_page.dart';  // Uncomment this
// import 'package:farmer_support_app/screens/login_screen.dart';  // Uncomment this
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/localization_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Add this line
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
      home: FutureBuilder<bool>(
        future: _checkIfLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while checking login status
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // If user is logged in, go to HomePage, otherwise show SplashScreen
          if (snapshot.data == true) {
            return HomePage();  // Navigate to home page if logged in
          } else {
            return SplashScreen();  // Show splash screen if not logged in
          }
        },
      ),
    );
  }

  // Function to check if user is logged in
  Future<bool> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}