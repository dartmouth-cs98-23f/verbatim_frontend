import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/logIn.dart';
import 'Components/defineRoutes.dart';
import 'Components/shared_prefs.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure WidgetsBinding is initialized
  await SharedPrefs().init();

  //String environment = String.fromEnvironment('FLUTTER_BACKEND_ENV', defaultValue: 'dev');
  //BackendService.loadProperties(environment);

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
