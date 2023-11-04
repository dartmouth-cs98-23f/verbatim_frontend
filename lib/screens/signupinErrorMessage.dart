import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/signUp.dart';

class SignupErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'lib/images/Logo.png',
                      width: 150,
                      height: 120,
                    ),
                  ),
                ),

                const SizedBox(height: 230),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Oops, something went wrong!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        height: 0.04,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'We encountered an error during sign-up/login. Please double-check your email and username.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to the 'SignUp' page
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFE76F51),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

