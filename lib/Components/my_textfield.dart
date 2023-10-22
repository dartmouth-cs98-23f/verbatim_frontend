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
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          fillColor: Color(0xFFF4F5F4),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xFF6C7476),
            fontSize: 14,
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w400,
            height: 0.10,
            letterSpacing: 0.20,
          )
        ),
      ),
    );
  }
}

