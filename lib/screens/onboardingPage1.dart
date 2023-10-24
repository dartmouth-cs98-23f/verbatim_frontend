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
    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return OnBoardingPage2(); // Replace 'YourNextPage' with the actual page you want to navigate to.
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verbatim',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 0.04,
                letterSpacing: 0.10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
