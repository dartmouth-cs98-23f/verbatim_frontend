import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final bool hasButtonImage;

  MyButton({
    Key? key, // Add the Key parameter here
    required this.buttonText,
    required this.hasButtonImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          width: 328,
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: ShapeDecoration(
            color: Color(0xFF1E4693),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    image: hasButtonImage ? DecorationImage(
                      image: AssetImage('lib/images/googleImage.png'),
                      fit: BoxFit.fill,
                    ) : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0), // Adjust the spacing as needed
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      height: 0.09,
                      letterSpacing: 0.30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
