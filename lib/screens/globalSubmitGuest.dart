import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatim_frontend/widgets/my_button_no_image.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/gameObject.dart';

import 'package:google_fonts/google_fonts.dart';

class Guest extends StatelessWidget {
  final String formattedTimeUntilMidnight;

  const Guest({
    super.key,
    required this.formattedTimeUntilMidnight,
  });

  @override
  Widget build(BuildContext context) {
    String copyIcon = 'assets/copy.svg';
    String sendIcon = 'assets/send.svg';
    String inviteText =
        "\nWant to know how your friend's responses compare to yours? Sign up to meet Verba-friends, create custom challenges, and compare scores!";
    // ignore: unused_element
    void onTap() {
      String routeName = ModalRoute.of(context)?.settings.name ?? '';
      Map<String, dynamic>? arguments = Uri.parse(routeName).queryParameters;

      if (arguments.containsKey('referer')) {
        referer = arguments['referer'];
      } else {
        referer = '';
      }

      Navigator.pushNamed(context, '/guest_signup');
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          // child: Padding(
          // padding: const EdgeInsets.only(left: 25, right: 25.0),

          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Verba',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFFE76F51),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextSpan(
                  text: '-tastic!',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ),
        ),
        const SizedBox(height: 8),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Text(
            inviteText,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        )),
        const SizedBox(height: 20),
        SizedBox(
          width: 220,
          child: Center(
            child: Text(
              'New Challenge in $formattedTimeUntilMidnight',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        MyButtonNoImage(
          buttonText: "Sign Up",
          onTap: onTap,
        ),
        const SizedBox(height: 15),
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Already have an account? ',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextSpan(
                  text: 'Sign in',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFF3C64B1),
                      fontWeight: FontWeight.w700,
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
    );
  }
}
