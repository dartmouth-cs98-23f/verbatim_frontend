import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/signUp.dart';
import 'logIn.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 70.0),
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
                      SizedBox(height: 40),
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
                      // Navigate to the 'Sign Up' page


                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUp()));


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE76F51), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(0.0), // Rectangular shape
                      ),
                    ),
                    child: const Text(
                      'Sign Up!',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins'
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                      children: [
                        TextSpan(
                          text: 'Sign-in',
                          style: const TextStyle(
                            color: Color(0xFF1E4693),
                            fontFamily: 'Poppins',
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to the 'Log In' page
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LogIn()));
                            },
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
