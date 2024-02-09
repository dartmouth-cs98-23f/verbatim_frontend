import 'package:flutter/material.dart';

class SuccessDialog {
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set the corner radius
          ),
          backgroundColor: const Color.fromARGB(
              255, 255, 243, 238), // Set the background color
          title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Verba',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '-tastic!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ), // Set text color
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Poppins',
                ), // Set button text color
              ),
            ),
          ],
        );
      },
    );
  }
}
