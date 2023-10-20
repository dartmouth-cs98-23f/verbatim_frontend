import 'dart:ui';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final bool hasButtonImage;
  final Function()? onTap;

  MyButton({
    Key? key,
    required this.buttonText,
    required this.hasButtonImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 328,
        height: 49,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: ShapeDecoration(
          color: Color(0xFF1E4693), // Set the background color here
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                image: hasButtonImage
                    ? DecorationImage(
                  image: AssetImage('lib/images/googleImage.png'),
                  fit: BoxFit.fill,
                )
                    : null,
                color: Color(0xFF1E4693), // Set the same background color
              ),
            ),
            SizedBox(width: 10), // Add some spacing between the image and text
            Align(
              alignment: Alignment.center,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w700,
                  height: 1.0, // Adjust height to center text vertically
                  letterSpacing: 0.30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
