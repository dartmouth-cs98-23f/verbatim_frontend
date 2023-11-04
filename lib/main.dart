import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/onboardingPage1.dart';
import 'Components/defineRoutes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
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
      initialRoute: '/onboarding_page1',
      home: OnBoardingPage1(),
    );
  }
}

