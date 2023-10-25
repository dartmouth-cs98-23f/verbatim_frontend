import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/getStarted.dart';
import 'package:verbatim_frontend/screens/onboardingPage3.dart';

class OnBoardingPage2 extends StatelessWidget {
  const OnBoardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
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
                        ),
                      ),
                      const SizedBox(height: 200),
                      Center(
                        child: Text(
                          'Discover \nShared Vocabulary',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            letterSpacing: 0.30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
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
                      primary: Color(0xFF1E4693), // Background color
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
