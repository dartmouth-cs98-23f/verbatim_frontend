import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatim_frontend/screens/logIn.dart';
import 'BackendService.dart';
import 'Components/defineRoutes.dart';
import 'Components/shared_prefs.dart';
import 'package:clipboard/clipboard.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure WidgetsBinding is initialized
  await SharedPrefs().init();

  const String environment =
      const String.fromEnvironment('FLUTTER_BACKEND_ENV', defaultValue: 'prod');
  print("env in main is: " + environment);
  BackendService.loadProperties(environment);

  runApp(const MyApp());
  defineRoutes();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //https://maketintsandshades.com/#E76F51 alternate shades are not yet added
    const MaterialColor paleColor = MaterialColor(
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
        850: Color(0xFF303030),
        900: Color(0xFF212121),
      },
    );

    return MaterialApp(
      theme: ThemeData(
        //primarySwatch: paleColor,
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 243, 238),
        textTheme: GoogleFonts.poppinsTextTheme(),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE76F51),
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      onGenerateRoute: Application.router.generator,
      initialRoute: SharedPrefs().getCurrentPage() ?? '/login',
      home: LogIn(),
    );
  }
}
