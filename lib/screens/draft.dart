import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/onboardingPage2.dart';

import 'getStarted.dart';

class Draft extends StatefulWidget {
  const Draft({Key? key});

  @override
  _DraftState createState() => _DraftState();
}

class _DraftState extends State<Draft> {
  // @override
  // void initState() {
  //   super.initState();
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return OnBoardingPage2();
  //       },
  //     ),
  //   );
  //   // Wait for 4 seconds and then navigate to the new page
  //   // Future.delayed(Duration(seconds: 3), () {
  //   //   Navigator.of(context).pushReplacement(
  //   //     MaterialPageRoute(
  //   //       builder: (context) {
  //   //         return OnBoardingPage2();
  //   //       },
  //   //     ),
  //   //   );
  //   // });
  // }

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
                  'assets/Logo.png', // Replace with the path to your image asset
                  width: 250, // Set the width and height to your preference
                  height: 300,
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GetStarted()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFF3EE), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13.0), // Rectangular shape
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OnBoardingPage2()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE76F51), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13.0), // Rectangular shape
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
