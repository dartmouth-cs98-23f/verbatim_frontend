import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/customChallenge.dart';

class CustomChallengeButton extends StatelessWidget {
  final bool drawButton;
  final String groupName;

  const CustomChallengeButton({
    Key? key,
    required this.drawButton,
    required this.groupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return an empty Container if drawButton is false
    if (!drawButton) return Container();

    // Otherwise, return the button
    return ElevatedButton(
      onPressed: () {
        // Navigate to CustomChallenge page
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => customChallenge(
                    groupName: groupName,
                  )),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE76F51), // Background color
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadowColor: const Color(0x60E87352),
        elevation: 4,
      ),
      child: Container(
        width: 280,
        height: 50,
        alignment: Alignment.center,
        child: const Text(
          'Start Custom Challenge',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.30,
          ),
        ),
      ),
    );
  }
}
