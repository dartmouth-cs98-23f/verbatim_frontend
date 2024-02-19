import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/widgets/donutChart.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';
import 'package:verbatim_frontend/widgets/size.dart';

class StatsContent extends StatelessWidget {
  final List<String> verbaMatchStatsContent;
  final double groupRating;
  final List<User> verbaMatchStatsUsers;

  const StatsContent({
    Key? key,
    required this.verbaMatchStatsContent,
    required this.groupRating,
    required this.verbaMatchStatsUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEmpty = verbaMatchStatsContent.isEmpty;
    String verb1 = isEmpty ? '' : verbaMatchStatsUsers[0].username;
    String verb2 = isEmpty ? '' : verbaMatchStatsUsers[1].username;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DonutChart(
                groupSimilarity: groupRating,
                title: 'Group Power Score',
              ),
            ),
          ),
          SizedBox(height: 15.v),
          Visibility(
            visible: !isEmpty,
            child: Container(
              child: Center(
                child: Text(
                  'Most Similar: ',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isEmpty,
            child: Container(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'No ',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: 'Verba-',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.orange,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: 'Matches...',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isEmpty,
            child: const SizedBox(
              height: 20,
            ),
          ),
          Visibility(
            visible: isEmpty,
            child: Container(
              child: Center(
                child: Text(
                  'Play more challenges to match!',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isEmpty,
            child: Container(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Verba',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.orange,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'Match!',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isEmpty,
            child: SizedBox(height: 10.v),
          ),
          Visibility(
            visible: verbaMatchStatsUsers.isNotEmpty,
            child: SizedBox(
              width: 200,
              height: 122,
              child: Stack(
                children: [
                  for (int i = 0; i < min(verbaMatchStatsUsers.length, 2); i++)
                    Positioned(
                      top: 0,
                      left: 35.0 + (i * 50),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: FirebaseStorageImage(
                          profileUrl: verbaMatchStatsUsers[i].profilePicture,
                          user: verbaMatchStatsUsers[i],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !isEmpty,
            child: SizedBox(height: 15.v),
          ),
          Visibility(
            visible: !isEmpty,
            child: verbaMatchStatsUsers.isNotEmpty
                ? Container(
                    child: Center(
                      child: Text(
                        '$verb1 and $verb2',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(), // Empty SizedBox to render nothing if verbaMatchStatsUsers is empty
          ),
          SizedBox(height: 50.v)
        ],
      ),
    );
  }
}
