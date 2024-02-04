import 'dart:js';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/widgets/my_button_no_image.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void clearSharedPrefs() async {
    await SharedPrefs().init();
    SharedPrefs().setEmail('');
    SharedPrefs().setUserName('');
    SharedPrefs().setPassword('');
    SharedPrefs().setFirstName('');
    SharedPrefs().setLastName('');
    SharedPrefs().setBio('');
    SharedPrefs().updateGameValues('', '','');
    SharedPrefs().updateReferer('');
    SharedPrefs().setCurrentPage('/global_challenge');
  }

  void onTap() {

    // String routeName = ModalRoute.of(this.context)?.settings.name ?? '';
    // Uri uri = Uri.parse(routeName);
    // Map<String, dynamic>? arguments = uri.queryParameters;
    // //String referer = '';
    // String referer = arguments['referer']?arguments['referer']: '';
    String routeName = ModalRoute.of(this.context)?.settings.name ?? '';
    Uri uri = Uri.parse(routeName);
    Map<String, dynamic>? arguments = uri.queryParameters;
    String referer = arguments?['referer'] ?? '';

    Navigator.pushNamed(this.context, '/global_challenge?referer=$referer');
  }

  @override
  Widget build(BuildContext context) {
    //clearSharedPrefs();
    clearSharedPrefs();
    return Scaffold(
      backgroundColor: Color(0xFFFFF3EE),
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
                  height: 300,
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
