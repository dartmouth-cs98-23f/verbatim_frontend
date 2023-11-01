import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/getStarted.dart';
import 'package:verbatim_frontend/screens/onboardingPage3.dart';

class OnBoardingPage2 extends StatelessWidget {
  const OnBoardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3EE),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),  //Color(0xFFFFF3EE)
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'lib/images/onboardingPage2Image.png', // Replace with the path to your image asset
                            width: 454, // Set the width and height to your preference
                            height: 354,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      Center(
                        child: Text(
                          'Discover \nShared Vocabulary',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFE76F51),
                            fontSize: 32,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            letterSpacing: 0.30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Do you have a shared vocabulary with your friends? Find out if you think what your friend thinks you think.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Mulish',
                              // fontWeight: FontWeight.w700,
                              height: 1.5,
                              letterSpacing: 0.30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the 'Sign Up' page
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetStarted()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0), // Rectangular shape
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the 'Sign Up' page
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OnBoardingPage3()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFE76F51), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0), // Rectangular shape
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
