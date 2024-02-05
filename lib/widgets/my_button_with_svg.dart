import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyButtonWithSvg extends StatelessWidget {
  final String buttonText;
  final String iconImage;
  final Function()? onTap;

  const MyButtonWithSvg({
    Key? key,
    required this.buttonText,
    required this.iconImage,
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
        decoration: ShapeDecoration(
          color: const Color(0xFFE76F51),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Material(
          // Use Material widget to enable ink splash
          color: Colors
              .transparent, // Make it transparent to prevent background color overlay
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: SvgPicture.asset(
                    iconImage, // Replace with your SVG file path
                    width: 20.0, // Adjust the width as needed
                    height: 20.0, // Adjust the height as needed
                    //change color to figma shade of white
                    color: Colors.white, // Change the icon color
                  ),
                ),
                const SizedBox(width: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
