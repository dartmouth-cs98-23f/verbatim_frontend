import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/onboardingPage2.dart';

class OnBoardingPage1 extends StatefulWidget {
  const OnBoardingPage1({Key? key});

  @override
  _OnBoardingPage1State createState() => _OnBoardingPage1State();
}

class _OnBoardingPage1State extends State<OnBoardingPage1> {
  @override
  void initState() {
    super.initState();
    // Wait for 4 seconds and then navigate to the new page
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return OnBoardingPage2();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3EE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'lib/images/Logo.png', // Replace with the path to your image asset
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
