import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:verbatim_frontend/widgets/size.dart';

class OnBoardingPage3 extends StatelessWidget {
  const OnBoardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3EE),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0), //Color(0xFFFFF3EE)
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/onboardingPage3Image.png', // Replace with the path to your image asset
                            width: 454
                                .v, // Set the width and height to your preference
                            height: 354.v,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Compare & \nCompete',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                            color: Color(0xFFE76F51),
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            letterSpacing: 0.30,
                          )),
                        ),
                      ),
                      SizedBox(height: 30.v),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                height: 1.5,
                                letterSpacing: 0.30,
                              )),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      'Most outrageous, funniest, most thoughtful? Play the global daily challenge and see how you measure up to the rest of the ',
                                ),
                                TextSpan(
                                  text: 'Verba',
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE76F51),
                                  )),
                                ),
                                TextSpan(
                                  text: 'world.',
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  )),
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
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the 'Global Challenge' page
                      Navigator.pushNamed(context, '/global_challenge');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFFF3EE), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13.0), // Rectangular shape
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                        color: Colors.black,
                      )),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the 'Onboarding page 4' page
                      Navigator.pushNamed(context, '/onboarding_page4');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFE76F51), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13.0), // Rectangular shape
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                        color: Colors.white,
                      )),
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
