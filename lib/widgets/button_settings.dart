import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeepOrangeButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const DeepOrangeButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE76F51),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(buttonText,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 0.06,
              letterSpacing: 0.30,
            ),
          )),
    );
  }
}
