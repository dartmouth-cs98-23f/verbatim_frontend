import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/friendship.dart';
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

// submit challenge

class groupChallenge extends StatefulWidget {
  final String groupName;
  final int? groupId;
  final List<String> challengeQs;
  final int challengeId;
  final bool completed;
  final List<dynamic>?
      groupAnswers; //dont need to send this i have question list lol but whatever no time
  final double? verbaMatchSimilarity;
  final int? totalResponses;
  final bool? fromFriend;

  groupChallenge({
    Key? key,
    required this.groupName,
    required this.groupId,
    required this.challengeQs,
    required this.challengeId,
    required this.completed,
    this.groupAnswers,
    this.verbaMatchSimilarity,
    this.totalResponses,
    this.fromFriend,
  }) : super(key: key);

  @override
  _GroupChallengeState createState() => _GroupChallengeState();
}

class _GroupChallengeState extends State<groupChallenge> {
// HARD CODED - load pics a diff way
  List<int> groupUsers = [1, 2, 3, 4, 5, 6];

//fix image getting but jsut use this for now
  Future<void> preloadImages(BuildContext context) async {
    for (int i = 0; i < min(groupUsers!.length + 1, 6); i++) {
      final key = 'assets/Ellipse ${41 + i}.png';
      final image = AssetImage(key);
      await precacheImage(image, context);
    }
  }

  String username = SharedPrefs().getUserName() ?? "";

  TextEditingController responseController = TextEditingController();
  String userResponse = '';
  List<String> userResponses = [];
  double progressValue = 0.0;
  int currentQuestionIndex = 0;
  List<String> questions = [];
  bool responded = false;

  List<bool> expandedStates = [];
  List<String> prompts = [];
  List<bool> editingStates = [];

  List<dynamic> groupAnswersSubmit = [];
  Map<String, Map<String, dynamic>> answersSubmitMap = {};

  Future<void> submitChallenge(
      String username, int challengeId, List<String> userResponses) async {
    final url =
        Uri.parse(BackendService.getBackendUrl() + 'submitGroupResponse');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final modifiedResponses = userResponses.map((response) {
      final responseWithoutPunctuation =
          response.replaceAll(RegExp(r'[^\w\s]'), '');

      final words = responseWithoutPunctuation
          .split(' ')
          .where((word) => word.isNotEmpty); // shld fix the whitespace thing

      final capitalizedWords = words.map((word) {
        if (word.isNotEmpty) {
          final trimmed = word.trim();

          return trimmed[0].toUpperCase() + trimmed.substring(1);
        }

        return word;
      });

// join them back into list<string>
      return capitalizedWords.join(' ');
    }).toList();

    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          'username': username,
          'responses': modifiedResponses,
          'challengeId': challengeId,
        }));

    if (response.statusCode == 200) {
      print('responses submitted succesfully');

      final Map<String, dynamic> stats = json.decode(response.body);
      print("stats when i submit $stats");
      // need to do lots of things to these stats!

      groupAnswersSubmit = stats["groupAnswers"];

      for (var answer in groupAnswersSubmit) {
        var question = answer['question'];
        var responses = answer['responses'];

        // Create a Map for the current question if not already created
        answersSubmitMap.putIfAbsent(question, () => {});

        // Iterate over responses and add them to the Map
        for (var user in responses.keys) {
          var response = responses[user];
          answersSubmitMap[question]![user] = response;
        }
      }
    } else {
      print("failedright here Status code: ${response.statusCode} ");
    }
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.challengeQs.length; i++) {
      expandedStates.add(false);

      String temp = widget.challengeQs[i];
      prompts.add(temp);
      editingStates.add(false);
    }

    expandedStates[0] = true;
  }

  void updateProgress() {
    setState(() {
      progressValue = (currentQuestionIndex + 1) / questions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> challengeQss = widget.challengeQs;

    if (widget.completed) {
      responded = true;
    }

    int numQuestions = widget.challengeQs.length;
    // how many questions are there?

    List<String> sentquestions = widget.challengeQs;

    questions = sentquestions;
    prompts = sentquestions;
    updateProgress();
    final String assetName = 'assets/img1.svg';
    List<dynamic>? groupAnswersStats = widget.groupAnswers;
    // get questions from groupAnswersStats

    Map<String, Map<String, dynamic>> answersMap = {};

    // get responses from groupAnswersStats
    if (groupAnswersStats != null) {
      for (var answer in groupAnswersStats) {
        var question = answer['question'];
        var responses = answer['responses'];

        // Create a Map for the current question if not already created
        answersMap.putIfAbsent(question, () => {});

        // Iterate over responses and add them to the Map
        for (var user in responses.keys) {
          var response = responses[user];
          answersMap[question]![user] = response;
        }
      }
    }

    final double? verbaMatchSimilarity2 = widget.verbaMatchSimilarity;
    final int? totalResponses2 = widget.totalResponses;
    bool comple = widget.completed;

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
                          height: 220,
                          width: double.maxFinite,
                          child:
                              Stack(alignment: Alignment.topCenter, children: [
                            // orange background
                            Container(
                              height: 200,
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
                        width: 300,
                        height: 400,
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
                                  if (userResponse == "") {
                                    print("U GOTTA SAY SOMETHING");
                                  } else {
                                    userResponses.add(userResponse);
                                    responseController.clear();
                                    if (currentQuestionIndex <=
                                        (numQuestions - 2)) {
                                      updateProgress();
                                      currentQuestionIndex += 1;
                                    } else {
                                      submitChallenge(
                                        username,
                                        widget.challengeId,
                                        userResponses,
                                      ).then((_) {
                                        setState(() {
                                          responded = true;
                                        });
                                      });
                                    }
                                  }
                                });
                              },
                              child: Text(
                                currentQuestionIndex == (numQuestions - 1)
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
                  for (int i = 0; i < numQuestions; i++)
                    if (widget.completed == true)
                      _buildResponseRectangle(i, answersMap),

                if (responded)
                  for (int x = 0; x < numQuestions; x++)
                    if (widget.completed == false)
                      _buildResponseRectangle(x, answersSubmitMap),

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
                      widget.fromFriend == true
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => friendship(
                                  friendUsername: widget.groupName,
                                ),
                              ),
                            )
                          : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => myGroup(
                                    groupName: widget.groupName,
                                    groupId: widget.groupId),
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

  Widget _buildResponseRectangle(
      int index, Map<String, Map<String, dynamic>> answersMap) {
// list of all users who have submitted responses
    Set<String> users = {};
    answersMap.forEach((question, userResponseMap) {
      users.addAll(userResponseMap.keys);
    });
    List<String> usersList = users.toList();

    List<bool> isDropdownVisible = [
      false,
      false,
      false,
      false,
      false
    ]; //how big shoudl this be?

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
                        itemCount: usersList.length,
                        itemBuilder: (context, indexB) {
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
                                  usersList[indexB],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  answersMap.containsKey(prompts[indexB]) &&
                                          answersMap[prompts[indexB]]!
                                              .containsKey(usersList[indexB])
                                      ? answersMap[prompts[index]]![
                                          usersList[indexB]]
                                      : 'No response found',
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
