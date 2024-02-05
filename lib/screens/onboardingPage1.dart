import 'package:flutter/material.dart';

class OnBoardingPage1 extends StatefulWidget {
  const OnBoardingPage1({super.key});

  @override
  _OnBoardingPage1State createState() => _OnBoardingPage1State();
}

class _OnBoardingPage1State extends State<OnBoardingPage1> {
  @override
  void initState() {
    super.initState();
    // Wait for 4 seconds and then navigate to the new page
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/onboarding_page2');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3EE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/Logo.png', // Replace with the path to your image asset
                  width: 250, // Set the width and height to your preference
                  height: 300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
