import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/logIn.dart';
import 'package:verbatim_frontend/screens/onboardingPage1.dart';
import 'package:verbatim_frontend/screens/signUp.dart';
import 'Components/defineRoutes.dart';
import 'Components/shared_prefs.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure WidgetsBinding is initialized
  await SharedPrefs().init();
  SharedPrefs().setEmail(''); // Reset email
  SharedPrefs().setUserName(''); // Reset username
  SharedPrefs().setPassword(''); // Reset password
  runApp(const MyApp());
  defineRoutes();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Set the navigatorKey
      onGenerateRoute: Application.router.generator,
      initialRoute: '/login',
      home: LogIn(),
    );
  }
}
