import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/create_group_app_bar.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/Components/defineRoutes.dart';
import 'package:verbatim_frontend/screens/myGroup.dart';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';

class groupChallenge extends StatefulWidget {
  groupChallenge({
    Key? key,
  }) : super(key: key);

  @override
  _GroupChallengeState createState() => _GroupChallengeState();
}

class _GroupChallengeState extends State<groupChallenge> {
  String username = SharedPrefs().getUserName() ?? "";
  int challengeID = 3;
  TextEditingController responseController = TextEditingController();
  String userResponse = '';
  List<String> userResponses = [];
  double progressValue = 0.0;
  int currentQuestionIndex = 0;
  List<String> questions = ["beep", "bpoo", "bopp"];
  bool responded = false;

  void updateProgress() {
    setState(() {
      progressValue = (currentQuestionIndex + 1) / questions.length;
    });
  }

  sendUserResponses(
      int challengeID, String username, List<String> userResponses) {
    print("ill send these to the backend for u");
  }

  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/img1.svg';

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Color.fromARGB(255, 255, 243, 238),
            body: SingleChildScrollView(
                child: Container(
                    color: Color.fromARGB(255, 255, 243, 238),
                    child: Column(children: [
                      SizedBox(
                          width: double.maxFinite,
                          child: Column(children: [
                            SizedBox(
                                height: 260.v,
                                width: double.maxFinite,
                                child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      // orange background
                                      Container(
                                        height: 220.v,
                                        width: double.maxFinite,
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.zero,
                                        child: SvgPicture.asset(
                                          assetName,
                                          fit: BoxFit.fill,
                                        ),
                                      ),

                                      // app bar on top of background
                                      CustomAppBar(),

                                      // 'Global Challenge #'
                                      Positioned(
                                        child: Center(
                                          child: Text(
                                            'Group Challenge',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]))
                          ])),
                      SizedBox(height: 30),
                      Stack(alignment: Alignment.bottomRight, children: [
                        Container(
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.only(top: 10.h),
                            //    padding: EdgeInsets.symmetric(horizontal: 10),
                            width: 300.h,
                            height: 500.v,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 117, 19, 12)
                                      .withOpacity(0.9),
                                  blurRadius: 5,
                                  offset: Offset(3, 7),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    questions[currentQuestionIndex],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: TextField(
                                    controller: responseController,
                                    onChanged: (value) {
                                      setState(() {
                                        userResponse = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Type your answer here...',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 255, 106, 0),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    minimumSize: Size(150, 40),
                                    padding: EdgeInsets.all(16),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      userResponse = responseController.text;
                                      userResponses.add(userResponse);
                                      responseController.clear();
                                      if (currentQuestionIndex <= 1) {
                                        updateProgress();
                                        currentQuestionIndex += 1;
                                      } else {
                                        sendUserResponses(
                                          challengeID,
                                          username,
                                          userResponses,
                                        );
                                        setState(() {
                                          responded = true;
                                        });
                                      }
                                    });
                                  },
                                  child: Text(
                                    currentQuestionIndex == 2
                                        ? 'Submit'
                                        : 'Next',
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: 200,
                                  child: LinearProgressIndicator(
                                    value: progressValue,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.orange),
                                    minHeight: 10,
                                  ),
                                ),
                              ],
                            ))
                      ])
                    ])))));
  }
}
