import 'package:flutter/material.dart';

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
                          'Discover Shared Vocabulary',
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
                      // Action for 'Skip' button
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Action for 'Next' button
                    },
                    style: ElevatedButton.styleFrom(primary: Color(0xFF1E4693)),
                    child: Text('Next'),
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
