import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verbatim_frontend/gameObject.dart';
import 'package:verbatim_frontend/widgets/my_button_no_image.dart';
import 'package:verbatim_frontend/widgets/my_button_with_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/my_button_with_image.dart';
import 'package:verbatim_frontend/screens/signUp.dart';

class Guest extends StatelessWidget {
  final String formattedTimeUntilMidnight;
  final GameObject data;

  const Guest({
    super.key,
    required this.formattedTimeUntilMidnight,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    String referer;
    String copyIcon = 'assets/copy.svg';
    String sendIcon = 'assets/send.svg';
    String inviteText =
        "\n Want to know how your friend's responses compare to yours? Sign up to meet Verba-friends, create custom challenges, and compare scores!";
    // ignore: unused_element
    void onTap() {
      String routeName = ModalRoute.of(context)?.settings.name ?? '';
      Map<String, dynamic>? arguments = Uri.parse(routeName).queryParameters;
      data.referer = arguments['referer'];
      //TODO: //ADDD THE ARGUMENTS: GAMEOBJECT

      Navigator.pushNamed(context, '/signup');
    }

    return Column(
      children: [
        SizedBox(height: 20),
        Center(
          // child: Padding(
          // padding: const EdgeInsets.only(left: 25, right: 25.0),

          child: RichText(
            text: const TextSpan(
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
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Text(
            inviteText,
            style: const TextStyle(
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
            //TODO: Change this
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUp(data: data),
              ),
            );
            //Navigator.pushNamed(context, '/signup');
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
