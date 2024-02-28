import 'dart:html';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
//import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/friendship.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/screens/myGroup.dart';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final List<dynamic>? verbaMatchUsers;

  const groupChallenge({
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
    this.verbaMatchUsers,
  }) : super(key: key);

  @override
  _GroupChallengeState createState() => _GroupChallengeState();
}

class _GroupChallengeState extends State<groupChallenge> {
// HARD CODED - load pics a diff way
  List<int> groupUsers = [1, 2, 3, 4, 5, 6];

//fix image getting but jsut use this for now
  Future<void> preloadImages(BuildContext context) async {
    for (int i = 0; i < min(groupUsers.length + 1, 6); i++) {
      final key = 'assets/Ellipse ${41 + i}.png';
      final image = AssetImage(key);
      await precacheImage(image, context);
    }
  }

  String username = window.sessionStorage['UserName'] ?? "";

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

// stats submit
  List<dynamic> groupAnswersSubmit = [];
  Map<String, Map<String, dynamic>> answersSubmitMap = {};
  List<dynamic> verbaMatchSubmit = [];
  double verbaMatchSimilaritySubmit = 0;

  void test() {
    print("In here at least");
  }

  Future<void> submitChallenge(
      String username, int challengeId, List<String> userResponses) async {
    final url =
        Uri.parse('${BackendService.getBackendUrl()}submitGroupResponse');
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
      print("these are stats on submit challenge $stats");

      // need to do lots of things to these stats!

      groupAnswersSubmit = stats["groupAnswers"];
      print("here before verbamatchsubmit assigned");
      verbaMatchSubmit = stats["verbaMatch"];
      print("here after verbamatchsubmit assigned");

      verbaMatchSimilaritySubmit = stats["verbaMatchSimilarity"];

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
    const String assetName = 'assets/img1.svg';
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

    final double verbaMatchSimilarity2 = widget.verbaMatchSimilarity ?? 0.0;
    final List<dynamic> verbaMatchUsers2 = widget.verbaMatchUsers ?? [];
    final int? totalResponses2 = widget.totalResponses;
    bool comple = widget.completed;

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 255, 243, 238),
      body: SingleChildScrollView(
          child: Container(
              color: const Color.fromARGB(255, 255, 243, 238),
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
                            const CustomAppBar(),

                            // 'Global Challenge #'
                            Positioned(
                              child: Center(
                                child: Text(
                                  responded
                                      ? 'Verba-Tastical!'
                                      : 'Group Challenge',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 27,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]))
                    ])),
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
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 117, 19, 12)
                                  .withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(3, 7),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Padding(padding: EdgeInsets.all(10),
                                                child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                questions[currentQuestionIndex],
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                controller: responseController,
                                onChanged: (value) {
                                  setState(() {
                                    userResponse = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Type your answer here...',
                                ),
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFFE76F51),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                minimumSize: const Size(150, 40),
                                padding: const EdgeInsets.all(16),
                              ),
                              onPressed: () {
                                setState(() {
                                  userResponse = responseController.text;
                                  if (userResponse == "") {
                                    // print("U GOTTA SAY SOMETHING");
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
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 200,
                              child: LinearProgressIndicator(
                                value: progressValue,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.orange),
                                minHeight: 10,
                              ),
                            ),
                          ],
                        ),
                        )

                      ),
                      Visibility(
                        visible: !responded,
                        child: Image.asset(
                          'assets/bird.png',
                          width: 83,
                        ),
                      )
                    ])),
                if (responded && widget.completed == true)
                  _verbaMatch(verbaMatchUsers2, verbaMatchSimilarity2)
                else if (responded && (widget.completed != true))
                  _verbaMatch(verbaMatchSubmit, verbaMatchSimilaritySubmit),
                if (responded)
                  Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(top: 10.v),
                    //    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 350,
                    height: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 117, 19, 12)
                              .withOpacity(0.9),
                          blurRadius: 5,
                          offset: const Offset(3, 7),
                        ),
                      ],
                      color: Colors.white,
                    ),

                    child: ListView.builder(
                      itemCount: numQuestions,
                      padding: EdgeInsets.only(top: 20),
                      itemBuilder: (context, index) {
                        if (!widget.completed) {
                          return _buildResponseRectangle(
                              index, answersSubmitMap);
                        } else {
                          return _buildResponseRectangle(index, answersMap);
                        }
                      },
                    ),
                  ),
                SizedBox(height: 50.v),
                Visibility(
                  visible: responded,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFE76F51),
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
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.v),
              ]))),
      drawer: const SideBar(),
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
      child: SingleChildScrollView(
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            //TODO:
            height: expandedStates[index] ? 120 : 50,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding:
                const EdgeInsets.only(top: 1, bottom: 1, left: 10, right: 10),
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
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                                                    const Padding(
                          padding:  EdgeInsets.only(
                              right: 5), // Adjust as needed
                          child: const Icon(Icons.arrow_drop_up),
                        ),
                          ],
                        ),
                      ),
                      Container(
                        //duration: const Duration(milliseconds: 1000),
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: usersList.length,
                          itemBuilder: (context, indexB) {
                            return Container(
                                height: 70,
                                width: 100,
                                margin: const EdgeInsets.only(
                                    left: 8, right: 8, top: 10),
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE76F51),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                    child: Column(children: [
                                  Flexible(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: 100,
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          usersList[indexB],
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            minWidth: 100,
                                          ),
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                answersMap.containsKey(
                                                            prompts[indexB]) &&
                                                        answersMap[prompts[
                                                                indexB]]!
                                                            .containsKey(
                                                                usersList[
                                                                    indexB])
                                                    ? answersMap[
                                                            prompts[index]]![
                                                        usersList[indexB]]
                                                    : 'No response found',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ))))
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
                        Flexible(
                          child: Text(
                            prompts[index],
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding:  EdgeInsets.only(
                              right: 5), // Adjust as needed
                          child: const Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                  ),
              ],
            ))),
      ),
    );
  }
}

Widget _verbaMatch(
    List<dynamic> verbaMatchInVerbaMatch, double verbaMatchSimilarity) {
  print("verbaMatchUsers: $verbaMatchInVerbaMatch");
  bool isThereVerbaMatch = verbaMatchInVerbaMatch.isNotEmpty;

  print("bool is there a verba match: $isThereVerbaMatch");

  print(
      "this is verbaMatchInVerbaMatch in _verba amtch $verbaMatchInVerbaMatch");
  // if there isnt a verbamatch hardcode it rn so it runs while i debug
  if (!isThereVerbaMatch) {
    print("in the if state");
    verbaMatchInVerbaMatch = ["empty", "verbamatch"];
    print("yea its empty");
  }
  String verb1 = verbaMatchInVerbaMatch[0];
  String verb2 = verbaMatchInVerbaMatch[1];
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
                    color:
                        const Color.fromARGB(255, 117, 19, 12).withOpacity(0.6),
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
                            Row(children: [
                              Image.asset('assets/Ellipse 42.png',
                                  height: 50, width: 50),
                              Image.asset('assets/Ellipse 43.png',
                                  height: 50, width: 50),
                            ]),
                            const SizedBox(height: 10),
                            Text(
                              '$verb1 and $verb2',
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
                                Container(
                                  height: 150,
                                  width: 150,
                                  alignment: Alignment.center,
                                  child: DonutChart(
                                      groupSimilarity: verbaMatchSimilarity,
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
                                      groupSimilarity: verbaMatchSimilarity,
                                      match: false),
                                ),
                              ]))
                    ],
                  )))));
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
