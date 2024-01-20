import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verbatim_frontend/widgets/my_button_no_image.dart';
import 'package:verbatim_frontend/widgets/my_button_with_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/my_button_with_image.dart';
import 'package:verbatim_frontend/screens/signUp.dart';

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
        "\n Want to know how your friend's responses compare to yours? Sign up to meet Verba-friends, create custom challenges, and compare scores!";

    return Column(
      children: [
        SizedBox(height: 20),
        Center(
          // child: Padding(
          // padding: const EdgeInsets.only(left: 25, right: 25.0),

          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Verba',
                  style: TextStyle(
                    color: Color(0xFFE76F51),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '-tastic!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // ),
        ),
        const SizedBox(height: 10),
        Center(
            child: Padding(
          padding: EdgeInsets.only(left:25, right:25),
          child: Text(
            inviteText,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        )),
        const SizedBox(height: 25),
        Container(
          width: 220,
          child: Center(
            child: Text(
              'New Challenge in $formattedTimeUntilMidnight',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        MyButtonNoImage(
          buttonText: "Sign Up",
          onTap: () {
            // Navigate to the sign-in page
            Navigator.pushNamed(context, '/signup');
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
