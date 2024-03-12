
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatim_frontend/widgets/my_button_no_image.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  


  void onTap() {
    String routeName = ModalRoute.of(context)?.settings.name ?? '';
    Uri uri = Uri.parse(routeName);

    Map<String, dynamic>? arguments = uri.queryParameters;
    String referer = arguments['referer'] ?? '';

    //check if theres a referer and propagate that info for guest
    Navigator.pushNamed(context, '/guest_global?referer=$referer');
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3EE),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/Logo.png', 
                  width: 250, 
                  height: 180,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Just in Time\nFor Our Global\nChallenge!",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 231, 111, 81),
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Give your juicy answers to our juicy questions and compare scores with our Verbafam.",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )),
            ),
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
