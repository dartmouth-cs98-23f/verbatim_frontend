import 'dart:convert';
import 'dart:html';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/BackendService.dart';

import 'package:http/http.dart' as http;
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';

class VerbaMatchWidget extends StatefulWidget {
  final List<dynamic> verbaMatchInVerbaMatch;
  final double verbaMatchSimilarity;

  const VerbaMatchWidget({
    Key? key,
    required this.verbaMatchInVerbaMatch,
    required this.verbaMatchSimilarity,
  }) : super(key: key);

  @override
  _VerbaMatchWidgetState createState() => _VerbaMatchWidgetState();
}

class _VerbaMatchWidgetState extends State<VerbaMatchWidget> {
  String verb1 = '';
  String verb2 = '';
  User? verbUser;
  bool isLoading = true;
  bool isThereVerbaMatch = false;

  @override
  void initState() {
    super.initState();
    _initializeUsers();
  }

  Future<void> _initializeUsers() async {
    if (widget.verbaMatchInVerbaMatch.isNotEmpty) {
      verb1 = widget.verbaMatchInVerbaMatch[0];
      verb2 = widget.verbaMatchInVerbaMatch[1];

      await getFriends(window.sessionStorage['UserName']!);
    }

    isThereVerbaMatch = widget.verbaMatchInVerbaMatch.isNotEmpty;
  }

  Future<void> getFriends(String username) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('${BackendService.getBackendUrl()}getFriends');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    try {
      final response = await http.post(url, headers: headers, body: username);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<User> userList =
            data.map((item) => User.fromJson(item)).toList();

        // Find users with matching usernames
        for (int i = 0; i < userList.length; i++) {
          if (userList[i].username == verb1 || userList[i].username == verb2) {
            verbUser =
                userList[i]; // Direct assignment, setState will be called later
          }
        }
      } else {
        print('Failed to send responses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("An error occurred: $e");
    } finally {
      // Ensure isLoading is set to false after the operation completes, success or fail
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? CircularProgressIndicator() : _buildVerbaMatchWidget();
  }

  Widget _buildVerbaMatchWidget() {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Align(
            alignment: Alignment.topCenter,
            child: Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 117, 19, 12)
                          .withOpacity(0.6),
                      blurRadius: 5,
                      offset: const Offset(3, 7),
                    ),
                  ],
                  color: Colors.white,
                ),
                // color: Colors.yellow,
                child: Padding(
                    padding: EdgeInsets.only(
                      top: 25,
                      left: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Visibility(
                          visible: !isThereVerbaMatch,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'No ',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Verba',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFE76F51),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Match",
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 10),
                              const Row(children: [
                                Icon(Icons.help_outline, size: 50),
                                Icon(Icons.help_outline, size: 50),
                              ]),
                              const SizedBox(height: 10),
                              Text(
                                '...yet!',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isThereVerbaMatch,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Verba',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFE76F51),
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Match!",
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: FirebaseStorageImage(
                                      profileUrl:
                                          window.sessionStorage['ProfileUrl']!,
                                    ),
                                  ),
                                  verbUser != null
                                      ? Container(
                                          width: 50,
                                          height: 50,
                                          child: FirebaseStorageImage(
                                            profileUrl:
                                                verbUser!.profilePicture,
                                            user: verbUser,
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment
                                              .center, // Align the icon to the center
                                          child: Icon(
                                            Icons
                                                .help_outline, // Show the help icon if verbaMatchInVerbaMatch is empty
                                            size: 50,
                                            color: Color(0xFFE76F51),
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.verbaMatchInVerbaMatch.isNotEmpty
                                    ? '${verb1.replaceFirstMapped(
                                        RegExp(r'^\w'),
                                        (match) => match
                                            .group(0)!
                                            .toUpperCase(), // Ensures the first letter of first name is capitalized.
                                      )} and ${verb2.replaceFirstMapped(
                                        RegExp(r'^\w'),
                                        (match) => match
                                            .group(0)!
                                            .toUpperCase(), // Ensures the first letter of first name is capitalized.
                                      )}'
                                    : "",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: isThereVerbaMatch,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: DonutChart(
                                        groupSimilarity:
                                            widget.verbaMatchSimilarity,
                                        match: true),
                                  ),
                                ])),
                        Visibility(
                            visible: !isThereVerbaMatch,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: DonutChart(
                                        groupSimilarity:
                                            widget.verbaMatchSimilarity,
                                        match: false),
                                  ),
                                ]))
                      ],
                    )))));
  }
}

class DonutChart extends StatefulWidget {
  final double groupSimilarity;
  final bool match;

  const DonutChart({
    Key? key,
    required this.groupSimilarity,
    required this.match,
  }) : super(key: key);

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  @override
  Widget build(BuildContext context) {
    Color calculateColor(double similarity) {
      int score = similarity.truncate();
      score = (score / 2).truncate();

      return Color.fromARGB(255, 250, 192 + score, 94 + score);
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          height: 180,
          width: 180,
          child: Column(
            children: [
              SizedBox(
                height: 125,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        startDegreeOffset: 250,
                        sectionsSpace: 0,
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                            value: widget.groupSimilarity,
                            color: const Color(0xFFE76F51),
                            radius: 19,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 100 - widget.groupSimilarity,
                            color: calculateColor(widget.groupSimilarity),
                            radius: 19,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    // text inside chart
                    Visibility(
                        visible: widget.match,
                        child: Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 243, 238),
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${widget.groupSimilarity.toStringAsFixed(2)}%",
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Similarity",
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    Visibility(
                        visible: !widget.match,
                        child: Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 243, 238),
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "?",
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
