import 'package:flutter/material.dart';
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
        '/global_challenge': (context) => globalChallenge(),
        '/add_friend': (context) => addFriend(),
      },
      home: globalChallenge(),
    );
  }
}
