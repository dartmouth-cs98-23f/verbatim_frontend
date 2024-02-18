import 'package:flutter/material.dart';
import '../widgets/my_button_no_image.dart';
import 'logIn.dart';

class SignupErrorMessage extends StatelessWidget {
  final String pageName;

  const SignupErrorMessage({super.key, required this.pageName});

  String getErrorMessage() {
    if (pageName == 'sign up') {
      return 'We encountered an error during sign-up. Please double-check your email and username.';
    } else if (pageName == 'log in') {
      return 'We encountered an error during log in. Please double-check your email or username and password.';
    } else {
      return 'Oops, something went wrong!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3EE),
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
                      'assets/Logo.png',
                      width: 150,
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 230),
                const Center(
                  child: Text(
                    'Oops, something went wrong!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE76F51),
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0.30,
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
                        getErrorMessage(), // Use the error message based on the pageName
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                MyButtonNoImage(
                  buttonText: 'Try Again',
                  onTap: () {
                    // Navigate back to the 'SignUp' page
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LogIn()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
