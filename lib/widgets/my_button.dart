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
    return SafeArea(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 333,
          height: 49,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: ShapeDecoration(
            color: Color(0xFFE76F51),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Material( // Use Material widget to enable ink splash
            color: Colors.transparent, // Make it transparent to prevent background color overlay
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      image: hasButtonImage
                          ? DecorationImage(
                        image: AssetImage('assets/googleImage.png'),
                        fit: BoxFit.fill,
                      )
                          : null,
                      //color: Color(0xFFE76F51),
                    ),
                  ),
                  SizedBox(width: 15),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
