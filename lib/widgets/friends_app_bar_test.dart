import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';

class FriendsAppBarTest extends StatelessWidget {
  final String title;
  const FriendsAppBarTest({
    Key? key,
    required this.title,
    this.height,
  }) : super(
          key: key,
        );

  final double? height;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: 430,
            height: 60.45,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 24,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 6),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 0.07,
                      letterSpacing: 0.10,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 145,
                  height: 40.45,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                ),
                const SizedBox(width: 10),
                SizedBox(
                    width: 40,
                    height: 40.45,
                    child: FirebaseStorageImage(
                      profileUrl: window.sessionStorage['ProfileUrl']?? "assets/profile_pic.png",
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
