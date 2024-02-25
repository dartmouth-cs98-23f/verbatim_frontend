import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/widgets/my_button_no_image.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  
  void clearSharedPrefs() {
    // await SharedPrefs().init();
    // SharedPrefs.setEmail('');
    // SharedPrefs.setUserName('');
    // SharedPrefs.setPassword('');
    // SharedPrefs.setFirstName('');
    // SharedPrefs.setLastName('');
    // SharedPrefs.setBio('');
   // window.sessionStorage.clear();
  
  }

  void onTap() {
    String routeName = ModalRoute.of(context)?.settings.name ?? '';
    Uri uri = Uri.parse(routeName);

    Map<String, dynamic>? arguments = uri.queryParameters;
    String referer = arguments['referer'] ?? '';

    //Navigator.pushNamed(context, '/guest_global');
    Navigator.pushNamed(context, '/guest_global?referer=$referer');
  }

// will this make shared preferences clear on opening?
  @override
  void initState() {
    super.initState();
    clearSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    //clearSharedPrefs();
    clearSharedPrefs();
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3EE),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/Logo.png', // Replace with the path to your image asset
                  width: 250, // Set the width and height to your preference
                  height: 180,
                ),
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Just in Time\nFor Our Global\nChallenge!",
                    style: TextStyle(
                      color: Color.fromARGB(255, 231, 111, 81),
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )),
            const SizedBox(height: 30),
            const Padding(
                padding: EdgeInsets.only(right: 50, left: 50),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Give your juicy answers to our juicy questions and compare scores with our Verbafam.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            MyButtonNoImage(buttonText: "Play Now!", onTap: onTap),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have an account? ',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'Sign in',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Color(0xFF3C64B1),
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to the sign-in page
                          Navigator.pushNamed(context, '/login');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
