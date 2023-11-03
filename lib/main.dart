import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbatim_frontend/screens/onboardingPage1.dart';
import 'package:verbatim_frontend/screens/signUp.dart';
import 'screens/globalChallenge.dart';
import 'screens/addFriend.dart';
import 'screens/settings.dart';
import 'Components/shared_prefs.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await SharedPrefs().init();
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
          '/global_challenge': (context) =>
              globalChallenge(username: '', email: '', password: ''),
          '/add_friend': (context) => addFriend(username: 'jenny l'),
          '/settings': (context)=> settings(),
        },
        home: SignUp());
        // home: globalChallenge(
        //     username: 'gh', email: 'gh@gmail.com', password: '0000000'));
  }
}
