import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the radius as needed
          border: Border.all(color: Color(0xFFE76F51)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0), // Adjust the left padding as needed
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              border: InputBorder.none, // Remove the default TextField border
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color(0xFF6C7476),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0.10,
                letterSpacing: 0.20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
