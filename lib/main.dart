import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/screens/logIn.dart';
import 'package:verbatim_frontend/screens/logout.dart';
import 'Components/defineRoutes.dart';
import 'Components/shared_prefs.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure WidgetsBinding is initialized
  await SharedPrefs().init();
  // SharedPrefs().setEmail('');
  // SharedPrefs().setUserName('');
  // SharedPrefs().setPassword('');
  // SharedPrefs().setFirstName('');
  // SharedPrefs().setLastName('');
  // SharedPrefs().setBio('');

  // new changes to solve the refresh issue

  String environment = String.fromEnvironment('FLUTTER_BACKEND_ENV', defaultValue: 'dev');
  BackendService.loadProperties(environment);
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

      initialRoute: SharedPrefs().getCurrentPage() ?? '/login',
      home: LogIn(),
    );
  }
}
