// Import the required packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorDialog {
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 243, 238),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Sign Up Error',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.orange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          content: Text(message,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              )), // Set text color
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ), // Set button text color
              ),
            ),
          ],
        );
      },
    );
  }
}
