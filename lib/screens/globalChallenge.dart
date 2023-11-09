import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sideBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/custom_tab.dart';
import 'dart:async';
import 'package:verbatim_frontend/widgets/stats.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:intl/intl.dart';
import 'verbatastic.dart';

class globalChallenge extends StatefulWidget {
  final String username = SharedPrefs().getUserName() ?? "";

  globalChallenge({
    Key? key,
  }) : super(key: key);

  @override
  _GlobalChallengeState createState() => _GlobalChallengeState();
}

String email = SharedPrefs().getEmail() ?? "";
String password = SharedPrefs().getPassword() ?? "";

class _GlobalChallengeState extends State<globalChallenge> {
  String userResponse = '';
  List<String> userResponses = [];
  TextEditingController responseController = TextEditingController();
  // Get questions and categories variables
  String question1 = "";
  String question2 = "";
  String question3 = "";
  String categoryQ1 = "";
  String categoryQ2 = "";
  String categoryQ3 = "";
  // Get Stats variables
  int totalResponses = 0;
  int numVerbatimQ1 = 0;
  int numVerbatimQ2 = 0;
  int numVerbatimQ3 = 0;
  int numExactVerbatim = 0;

  Map<String, List<String>?> verbatasticUsers = {};
  List<String>? verbatasticUsernames = [];
  List<String> modResponse = [];
  String verbatimedWord = "";

  Map<String, dynamic> statsQ1 = {
    "firstMostPopular": "",
    "numResponsesFirst": 0,
    "secondMostPopular": "",
    "numResponsesSecond": 0,
    "thirdMostPopular": "",
    "numResponsesThird": 0,
    "friendResponses": [],
  };
  Map<String, dynamic> statsQ2 = {
    "firstMostPopular": "",
    "numResponsesFirst": 0,
    "secondMostPopular": "",
    "numResponsesSecond": 0,
    "thirdMostPopular": "",
    "numResponsesThird": 0,
    "friendResponses": [],
  };
  Map<String, dynamic> statsQ3 = {
    "firstMostPopular": "",
    "numResponsesFirst": 0,
    "secondMostPopular": "",
    "numResponsesSecond": 0,
    "thirdMostPopular": "",
    "numResponsesThird": 0,
    "friendResponses": [],
  };

  bool responded = false;
  List<String> responses = List.filled(3, "");
  String fetchQuestions = "";
  int currentQuestionIndex = 0;
  List<String> questions = ["", "", ""];

  final StreamController<bool> _streamController = StreamController<bool>();
  double progressValue = 0.0;

  Future<void> _fetchData(String username) async {
    final url = Uri.parse('http://localhost:8080/api/v1/globalChallenge');
    final headers = <String, String>{'Content-Type': 'application/json'};

    final fetchQuestions =
        await http.post(url, headers: headers, body: username);

    if (fetchQuestions.statusCode == 200) {
      print(fetchQuestions.body);
      final Map<String, dynamic>? data = json.decode(fetchQuestions.body);

      question1 = data!['q1'];
      print(question1);
      question2 = data['q2'];
      print(question2);
      question3 = data['q3'];

      categoryQ1 = data['categoryQ1'];
      categoryQ2 = data['categoryQ2'];
      categoryQ3 = data['categoryQ3'];
      totalResponses = data['totalResponses'];

      // if null, user has not yet submitted global response

      if (data["responseQ1"] != null) {
        numVerbatimQ1 = data['numVerbatimQ1'];
        numVerbatimQ2 = data['numVerbatimQ2'];
        numVerbatimQ3 = data['numVerbatimQ3'];
        statsQ1 = data['statsQ1'];
        statsQ2 = data['statsQ2'];
        statsQ3 = data['statsQ3'];
        totalResponses = data['totalResponses'];
        responded = true;
        verbatasticUsers = (data["verbatasticUsers"] as Map<String, dynamic>?)
                ?.map((key, value) {
              return MapEntry(key, (value as List).cast<String>());
            }) ??
            {};

        if (verbatasticUsers.isNotEmpty) {
          final MapEntry<String, List<String>?>? firstEntry =
              verbatasticUsers.entries.first;

          if (firstEntry != null) {
            verbatimedWord = firstEntry.key;
            verbatasticUsernames = firstEntry.value;

            print("First key: $verbatimedWord");
            print("First value: $verbatasticUsernames");
          } else {
            print("The first entry is null");
          }
        } else {
          print("verbatasticUsers is empty");
        }

        print(
            'this is verbatasticUsers from send user responses $verbatasticUsers');

        print('this is verbatasticUsers from _fetchdata $verbatasticUsers');
        print(
            'this is data from _fetchdata global response when user has played $data');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(widget.username).then((_) {
      setState(() {
        questions = [question1, question2, question3];
      });
    });
  }

  Future<void> sendUserResponses(
      String username, String email, List<String> userResponses) async {
    final url = Uri.parse('http://localhost:8080/api/v1/submitGlobalResponse');
    final headers = <String, String>{'Content-Type': 'application/json'};

    final modifiedResponses = userResponses.map((response) {
      final responseWithoutPunctuation =
          response.replaceAll(RegExp(r'[^\w\s]'), '');

      final words = responseWithoutPunctuation.split(' ');

      final capitalizedWords = words.map((word) {
        if (word.isNotEmpty) {
          return word[0].toUpperCase() + word.substring(1);
        }
        return word;
      });

      // Join the words back into a sentence
      return capitalizedWords.join(' ');
    }).toList();

    print(modifiedResponses);
    print(username);
    print(email);
    modResponse = modifiedResponses;

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({
        'username': username,
        'responseQ1': modifiedResponses[0],
        'responseQ2': modifiedResponses[1],
        'responseQ3': modifiedResponses[2]
      }),
    );

    if (response.statusCode == 200) {
      print('Responses sent successfully');

      final Map<String, dynamic> stats = json.decode(response.body);
      print(stats);
      numVerbatimQ1 = stats['numVerbatimQ1'];
      numVerbatimQ2 = stats['numVerbatimQ2'];
      numVerbatimQ3 = stats['numVerbatimQ3'];
      statsQ1 = stats['statsQ1'];
      statsQ2 = stats['statsQ2'];
      statsQ3 = stats['statsQ3'];
      verbatasticUsers = (stats["verbatasticUsers"] as Map<String, dynamic>?)
              ?.map((key, value) {
            return MapEntry(key, (value as List).cast<String>());
          }) ??
          {};

      if (verbatasticUsers.isNotEmpty) {
        final MapEntry<String, List<String>?>? firstEntry =
            verbatasticUsers.entries.first;

        if (firstEntry != null) {
          verbatimedWord = firstEntry.key;
          verbatasticUsernames = firstEntry.value;

          print("First key: $verbatimedWord");
          print("First value: $verbatasticUsernames");
        } else {
          print("The first entry is null");
        }
      } else {
        print("verbatasticUsers is empty");
      }

      totalResponses = stats['totalResponses'];
      print(
          'this is verbatasticUsers from send user responses $verbatasticUsers');

      //  await getVerbatimedWord();

      responded = true;
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');

      print('Response body: ${response.body}');
    }
  }

  void updateProgress() {
    setState(() {
      progressValue = (currentQuestionIndex + 1) / questions.length;
    });
  }

  Future<void> getVerbatimedWord() async {
    final Iterable<String> verbatimedQuestion = verbatasticUsers.keys.toList();
    final String questionNumber = verbatimedQuestion.first;

    verbatasticUsernames = verbatasticUsers[questionNumber]!;

    final String responseIndex =
        questionNumber.isNotEmpty ? questionNumber[1] : "";
    final int? index = int.tryParse(responseIndex);

    if (index != null) {
      verbatimedWord = modResponse[index - 1];
      print('this is verbatimed word $verbatimedWord');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime midnight =
        DateTime(now.year, now.month, now.day + 1); // Set to next midnight

    Duration timeUntilMidnight = midnight.difference(now);

    String formattedTimeUntilMidnight =
        DateFormat.Hms().format(DateTime(0).add(timeUntilMidnight));

    final String assetName = 'assets/img1.svg';
    List<String> tabLables = [
      categoryQ1,
      categoryQ2,
      categoryQ3
    ]; //eventually need backend to send this in

    bool showText = true;
    updateProgress();

    void toggleTextVisibility() {
      _streamController.sink.add(!showText);
      showText = !showText;
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromARGB(255, 255, 243, 238),
        body: SingleChildScrollView(
          child: Container(
              color: Color.fromARGB(255, 255, 243, 238),
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
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
                                    'Global Challenge #17',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),

                              // x users have played
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  width: 152.h,
                                  margin: EdgeInsets.only(left: 32.h),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '$totalResponses',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        TextSpan(
                                            text: " users have played today",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),

                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: 100,
                                    clipBehavior: Clip.hardEdge,
                                    margin: EdgeInsets.only(right: 20.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.transparent),
                                    height: 30,
                                    child: PlayTab(
                                      onTabSelectionChanged:
                                          (bool isFirstTabSelected) {
                                        toggleTextVisibility();
                                      },
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.symmetric(horizontal: 10),
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
                            StreamBuilder<bool>(
                                stream: _streamController.stream,
                                initialData: true,
                                builder: (context, snapshot) {
                                  if (snapshot.data! && responded == false) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 30),
                                        Text(
                                          questions[currentQuestionIndex],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 30.0),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: TextField(
                                            controller: responseController,
                                            onChanged: (value) {
                                              setState(() {
                                                userResponse = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Type your answer here...',
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 40.0),
                                        //not sure why this focus isn't listening - smth to figure out for next term maybe?

                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 255, 106, 0),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            minimumSize: Size(150, 40),
                                            padding: EdgeInsets.all(16),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              userResponse =
                                                  responseController.text;
                                              userResponses.add(userResponse);
                                              responseController.clear();
                                              if (currentQuestionIndex <= 1) {
                                                updateProgress();
                                                // If not the last question, go to the next question.
                                                currentQuestionIndex += 1;
                                              } else {
                                                // If the last question, set 'response' to true

                                                sendUserResponses(
                                                  widget.username,
                                                  email,
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.orange),
                                            minHeight: 10,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (responded == false) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 20.0),
                                        Column(
                                          children: [
                                            SizedBox(height: 50),
                                            Center(
                                              child: Text(
                                                'Play the',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'challenge',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'to see ',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'Global Stats!',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else if (!snapshot.data! &&
                                      responded == true) {
                                    return Column(children: [
                                      Container(
                                          width: 300.h,
                                          height: 500.v,
                                          child: Stats(
                                              totalResponses: totalResponses,
                                              tabLabels: tabLables,
                                              statsQ1: statsQ1,
                                              statsQ2: statsQ2,
                                              statsQ3: statsQ3))
                                    ]);
                                  } else {
                                    return FutureBuilder<void>(
                                      future: _fetchData(widget.username),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // Loading indicator
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          // Handle the error
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return Column(
                                            children: [
                                              Verbatastic(
                                                verbatimedWord: verbatimedWord,
                                                formattedTimeUntilMidnight:
                                                    formattedTimeUntilMidnight,
                                                verbatasticUsernames:
                                                    verbatasticUsernames,
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    );
                                  }

/*
                                    return Column(children: [
                                      Container(
                                          width: 300.h,
                                          height: 500.v,
                                          child: Verbatastic(
                                            verbatimedWord: verbatimedWord,
                                            formattedTimeUntilMidnight:
                                                formattedTimeUntilMidnight,
                                            verbatasticUsernames:
                                                verbatasticUsernames,
                                          ))
                                    ]);
*/
                                }),
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
                    ],
                  )
                ],
              )),
        ),
        drawer: SideBar(),
      ),
    );
  }
}
