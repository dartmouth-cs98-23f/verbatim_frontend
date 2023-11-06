import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/screens/globalChallenge.dart';
import 'package:verbatim_frontend/screens/onboardingPage1.dart';
import 'Components/defineRoutes.dart';
import 'Components/shared_prefs.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await SharedPrefs().init();
  runApp(const MyApp());
  defineRoutes();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String username = SharedPrefs().getUserName() ?? "";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Set the navigatorKey
      onGenerateRoute: Application.router.generator,
      initialRoute: '/onboarding_page1',
      home: OnBoardingPage1(),
    );
  }
}
