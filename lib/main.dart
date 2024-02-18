import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:verbatim_frontend/gameObject.dart';
import 'package:verbatim_frontend/screens/landingPage.dart';
import 'BackendService.dart';
import 'Components/defineRoutes.dart';
import 'Components/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();

  const String environment =
      String.fromEnvironment('FLUTTER_BACKEND_ENV', defaultValue: 'prod');
  await dotenv.load(fileName: ".env");

  BackendService.loadProperties(environment);
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['apiKey']!,
        appId: dotenv.env['appId']!,
        messagingSenderId: dotenv.env['messagingSenderId']!,
        projectId: dotenv.env['projectId']!,
        storageBucket: dotenv.env['storageBucket']!,
      ),
    );
  } catch (e) {
    print('\n\nError initializing Firebase: $e\n\n');
  }

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
        // primarySwatch: paleColor,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 243, 238),
        textTheme: GoogleFonts.poppinsTextTheme(),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE76F51),
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      onGenerateRoute: Application.router.generator,
      //initialRoute: SharedPrefs().getCurrentPage() ?? '/landingPage',
      home: const LandingPage(),
    );
  }
}
