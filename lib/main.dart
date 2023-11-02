import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/onboardingPage4.dart';
import 'package:verbatim_frontend/screens/signUp.dart';
import 'package:verbatim_frontend/screens/onboardingPage1.dart';
import 'screens/globalChallenge.dart';
import 'screens/addFriend.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Set the navigatorKey

      routes: {
        '/global_challenge': (context) => globalChallenge(
            username: 'dd', email: 'dd@gmail.com', password: '0000000'),
        '/add_friend': (context) => addFriend(username: 'jenny l'),
      },

      home: OnBoardingPage1(),
      /*
        home: globalChallenge(
            username: 'evewening',
            email: 'evewening@gmail.com',
            password: '0000000')*/
    );
  }
}
