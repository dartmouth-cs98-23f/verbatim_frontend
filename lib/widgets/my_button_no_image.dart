// Import the required packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButtonNoImage extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;

  const MyButtonNoImage({
    Key? key,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 328,
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
                  const SizedBox(width: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                      child: Text(
                        buttonText,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: 0.30,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
