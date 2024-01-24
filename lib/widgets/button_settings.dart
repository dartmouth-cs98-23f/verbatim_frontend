import 'package:flutter/material.dart';

class DeepOrangeButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  DeepOrangeButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE76F51),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          height: 0.06,
          letterSpacing: 0.30,
        ),
      ),
    );
  }
}
