import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
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
import 'dart:math';

//fix image getting but jsut use this for now
Future<void> preloadImages(BuildContext context) async {
  for (int i = 0; i < min(groupUsers!.length + 1, 6); i++) {
    final key = 'assets/Ellipse ${41 + i}.png';
    final image = AssetImage(key);
    await precacheImage(image, context);
  }
}

class groupChallenge extends StatefulWidget {
  final String groupName;
  groupChallenge({
    Key? key,
    required this.groupName,
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
  List<String> questions = ["beep", "bpoo", "bopp", "poop", "werewr"];
  bool responded = false;

  List<bool> expandedStates = [false, false, false];
  List<String> prompts = [
    "challenge question one",
    "challenge question two",
    "challenge question three",
  ];
  List<bool> editingStates = [false, false, false];

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
    updateProgress();
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
                          height: 220.v,
                          width: double.maxFinite,
                          child:
                              Stack(alignment: Alignment.topCenter, children: [
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
                                  responded
                                      ? 'Verba-Tastical!'
                                      : 'Group Challenge',
                                  style: TextStyle(
                                    fontSize: 27,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ]))
                    ])),
                // SizedBox(height: 30),
                Visibility(
                    visible: !responded,
                    child: Stack(alignment: Alignment.bottomRight, children: [
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                                currentQuestionIndex == 2 ? 'Submit' : 'Next',
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
                        ),
                      ),
                      Visibility(
                        visible: !responded,
                        child: Image.asset(
                          'assets/bird.png',
                          width: 83,
                        ),
                      )
                    ])),
                if (responded) _verbaMatch(),
                if (responded)
                  for (int i = 0; i < prompts.length; i++)
                    _buildResponseRectangle(i),
                SizedBox(height: 50.v),

                Visibility(
                  visible: responded,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFE76F51),
                      enableFeedback: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(150, 50),
                    ),
                    // add 'create challenge'
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              myGroup(groupName: widget.groupName),
                        ),
                      );
                    }, //send prompts to backend

                    child: Text(
                      'Back to Challenge Feed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.v),
              ]))),
      drawer: SideBar(),
    ));
  }

  Widget _buildResponseRectangle(int index) {
    List<String> items = ['You', 'Jackie', 'Dahlia', 'Ryan', 'Eve'];
    List<String> answers = [
      'beep',
      'bop',
      'kleep',
      'klop',
      'longone',
      'beep',
    ];
    String selectedValue = 'Item 1';
    List<bool> isDropdownVisible = [false, false, false];

    return GestureDetector(
      onTap: () {
        setState(() {
          expandedStates[index] = !expandedStates[index];
          isDropdownVisible[index] = expandedStates[index];
        });
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          height: expandedStates[index] ? 120 : 50,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          padding: EdgeInsets.all(8),

          //remove this decoration?
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF9E503C).withOpacity(1),
                blurRadius: 5,
                offset: Offset(2, 3),
              )
            ],
          ),
          child: SingleChildScrollView(
              child: Column(
            children: [
              //if clicked on
              Visibility(
                visible: expandedStates[index],
                child: Column(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              prompts[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_upward),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedValue == items[index];
                          return Container(
                              height: 40.v,
                              width: 100.h,
                              margin:
                                  EdgeInsets.only(left: 8, right: 8, top: 10),
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFE76F51),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                  child: Column(children: [
                                Text(
                                  items[index],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  answers[index],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                )
                              ])));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // if not clicked on
              if (!expandedStates[index])
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          prompts[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_downward),
                    ],
                  ),
                ),
            ],
          ))),
    );
  }
}

Widget _verbaMatch() {
  return Align(
      alignment: Alignment.topCenter,
      child: Container(
          width: 600.v,
          height: 200.v,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Verba',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE76F51),
                              fontSize: 23),
                        ),
                        TextSpan(
                            text: "Match!",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  Row(children: [
                    Image.asset('assets/Ellipse 42.png', height: 50, width: 50),
                    Image.asset('assets/Ellipse 43.png', height: 50, width: 50),
                  ]),
                  SizedBox(height: 10),
                  Text(
                    'Jackie and Eric',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  height: 200.v,
                  width: 200.v,
                  alignment: Alignment.center,
                  child: DonutChart(groupSimilarity: 67),
                ),
              ])
            ],
          )));
}

class DonutChart extends StatefulWidget {
  final double groupSimilarity;

  DonutChart({
    Key? key,
    required this.groupSimilarity,
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
        body: Container(
          height: 200.v,
          width: 200.v,
          child: Column(
            children: [
              SizedBox(height: 15.v),
              SizedBox(
                height: 125.v,
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
                            color: Color(0xFFE76F51),
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
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 80.v,
                            width: 80.h,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 243, 238),
                              shape: BoxShape.circle,
                              /*
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(132, 155, 131, 121),
                                    blurRadius: 10.0,
                                    spreadRadius: 10.0,
                                    offset: const Offset(3, 3)),
                              ],
                              */
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${widget.groupSimilarity.toStringAsFixed(2)}%",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Similarity",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class HorizontalScrollDropdown extends StatefulWidget {
  @override
  _HorizontalScrollDropdownState createState() =>
      _HorizontalScrollDropdownState();
}

class _HorizontalScrollDropdownState extends State<HorizontalScrollDropdown> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  String selectedValue = 'Item 1';
  bool isDropdownVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDropdownVisible = !isDropdownVisible;
                  });
                },
                child: Text(
                  selectedValue,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          if (isDropdownVisible)
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedValue == items[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = items[index];
                        isDropdownVisible = false;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  Colors.orange.shade800,
                                  Colors.orange.shade500
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.orange.shade200,
                                  Colors.orange.shade100
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        items[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
