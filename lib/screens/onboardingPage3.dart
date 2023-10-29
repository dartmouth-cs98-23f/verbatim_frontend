import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/onboardingPage4.dart';

import 'getStarted.dart';

class OnBoardingPage3 extends StatelessWidget {
  const OnBoardingPage3({super.key});

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
                          'Compare & \nCompete',
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

                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                height: 1.5,
                                letterSpacing: 0.30,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Most outrageous, funniest, most thoughtful? Play the global daily challenge and see how you measure up to the rest of the ',
                                ),
                                TextSpan(
                                  text: 'Verba',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE76F51),
                                  ),
                                ),
                                TextSpan(
                                  text: 'world.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => OnBoardingPage4()));
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
