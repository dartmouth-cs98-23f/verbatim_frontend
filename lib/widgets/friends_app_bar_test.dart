import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/sideBar.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';
import 'size.dart';
import 'package:http/http.dart' as http;

class FriendsAppBarTest extends StatelessWidget {
  FriendsAppBarTest({
    Key? key,
    this.height,
  }) : super(
          key: key,
        );

  final double? height;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 390,
          height: 60.45,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 6),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      // child: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => SideBar()),
                      //         );
                      //       },
                      //       icon: Icon(
                      //         Icons.menu,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Add Friends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0.07,
                  letterSpacing: 0.10,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 145,
                height: 40.45,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
              ),
              const SizedBox(width: 10),
              Container(
                  width: 40, height: 40.45, child: FirebaseStorageImage()),
            ],
          ),
        ),
      ],
    );
  }
}
