import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

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
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Action for 'Sign Up' button
                    },
                    style: ElevatedButton.styleFrom(primary: Color(0xFF1E4693)),
                    child: Text('Sign Up!'),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign-in',
                          style: TextStyle(
                            color: Color(0xFF1E4693), // Blue color for hyperlink
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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
