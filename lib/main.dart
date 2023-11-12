import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbatim_frontend/screens/globalChallenge.dart';
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

  runApp(const MyApp());
  defineRoutes();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String hexColor = "#E76F51";

//https://maketintsandshades.com/#E76F51
    const MaterialColor myOrangeColor = MaterialColor(
      0xFFF3EE,
      <int, Color>{
        50: Color(0xFFFAFAFA),
        100: Color(0xFFF5F5F5),
        200: Color(0xFFEEEEEE),
        300: Color(0xFFE0E0E0),
        350: Color(0xFFD6D6D6),
        400: Color(0xFFBDBDBD),
        500: Color(0xFF9E9E9E),
        600: Color(0xFF757575),
        700: Color(0xFF616161),
        800: Color(0xFF424242),
        850: Color(0xFF303030), // only for background color in dark theme
        900: Color(0xFF212121),
      },
    );

    return MaterialApp(
      theme: ThemeData(primarySwatch: myOrangeColor),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      onGenerateRoute: Application.router.generator,
      initialRoute: SharedPrefs().getCurrentPage() ?? '/globalChallenge',
      home: globalChallenge(),
    );
  }
}
