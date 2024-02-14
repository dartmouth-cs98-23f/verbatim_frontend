import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verbatim_frontend/screens/profile.dart';

import '../screens/User.dart';

class FirebaseStorageImage extends StatelessWidget {
  final String profileUrl;
  final User? user;

  const FirebaseStorageImage({Key? key, required this.profileUrl, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: downloadImage(profileUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(user: user!)),
                );
              } else {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Profile()),

                // );
                // SharedPrefs().setCurrentPage('/profile');
                Navigator.pushNamed(context, '/profile');
              }
            },
            child: Container(
              width: 40,
              height: 40.45,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: MemoryImage(snapshot.data!),
                  fit: BoxFit.fill,
                ),
                shape: const CircleBorder(),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () {
              // Navigate to the Profile page
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Profile()),
              // );
              Navigator.pushNamed(
                context,
                '/profile',
              );
            },
            child: Container(
              width: 40,
              height: 40.45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/profile_pic.png'),
                ),
              ),
            ),
          ); // Placeholder widget while image is loading
        }
      },
    );
  }

  Future<Uint8List> downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download image');
    }
  }
}
