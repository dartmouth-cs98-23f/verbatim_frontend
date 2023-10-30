import 'package:flutter/material.dart';
import 'sideBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/custom_tab.dart';
import 'dart:async';
import 'package:verbatim_frontend/widgets/stats.dart';

class globalChallenge extends StatefulWidget {
  final String email;
  final String username;
  final String password;

  globalChallenge({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _GlobalChallengeState createState() => _GlobalChallengeState();
}

class _GlobalChallengeState extends State<globalChallenge> {
  String userResponse = '';
  List<String> userResponses = [];
  TextEditingController responseController = TextEditingController();
  String question1 = "";
  String question2 = "";
  String question3 = "";

  bool response = false;
  List<String> responses = List.filled(3, "");
  String fetchQuestions = "";
  int currentQuestionIndex = 0;
  List<String> questions = ["", "", ""];

  final StreamController<bool> _streamController = StreamController<bool>();
  double progressValue = 0.0;

  Future<void> _fetchData() async {
    final fetchQuestions = await http
        .get(Uri.parse('http://localhost:8080/api/v1/globalChallenge'));

    if (fetchQuestions.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(fetchQuestions.body);

      question1 = data['q1'];
      question2 = data['q2'];
      question3 = data['q3'];
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData().then((_) {
      setState(() {
        questions = [question1, question2, question3];
      });
    });
  }

  Future<void> sendUserResponses(
      String username, String email, List<String> userResponses) async {
    final url = Uri.parse('http://localhost:8080/api/v1/submitGlobalResponse');
    final headers = <String, String>{'Content-Type': 'application/json'};
    print(userResponses);
    print(username);
    print(email);

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({
        'username': username,
        'responseQ1': userResponses[0],
        'responseQ2': userResponses[1],
        'responseQ3': userResponses[2]
      }),
    );

    if (response.statusCode == 200) {
      print('Responses sent successfully');
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

  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/img1.svg';
    List<String> tabLables = [
      'Sports',
      'Fruits',
      'Costumes'
    ]; //eventually need backend to send this in

    bool showText = true;
    updateProgress();

    void toggleTextVisibility() {
      _streamController.sink.add(!showText);
      showText = !showText;
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Color.fromARGB(255, 255, 243, 238),
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(
                      height: 240.v,
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
                                '\nGlobal Challenge #17',
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
                                      text: "17213",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15),
                                    ),
                                    TextSpan(
                                        text: " users have played",
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
                    height: 400.v,
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
                            if (snapshot.data! && response == false) {
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
                                  Visibility(
                                    visible: !response,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
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
                                            // If the last question, set 'response' to true to submit.
                                            setState(() {
                                              response = true;
                                            });
                                            sendUserResponses(
                                              widget.username,
                                              widget.email,
                                              userResponses,
                                            );
                                          }
                                        });
                                      },
                                      child: Text(
                                        currentQuestionIndex == 2
                                            ? 'Submit'
                                            : 'Next',
                                      ),
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
                              );
                            } else if (response == false) {
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
                            } else if (!snapshot.data! && response == true) {
                              return Column(children: [
                                Container(
                                    width: 300,
                                    height: 300,
                                    child: Stats(tabLabels: tabLables))
                              ]);
                            } else {
                              return Column(
                                children: [
                                  SizedBox(height: 20),
                                  Center(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 100.0),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Verba',
                                                  style: TextStyle(
                                                      color: Colors.orange,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: '-tastic!',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ))),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 200,
                                    height: 48,
                                    child: Stack(
                                      children: [
                                        Icon(Icons.mood,
                                            size: 48, color: Colors.orange),
                                        Positioned(
                                          top: 0,
                                          left: 30,
                                          child: Icon(Icons.mood,
                                              size: 48, color: Colors.blue),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 60,
                                          child: Icon(Icons.mood,
                                              size: 48, color: Colors.green),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 90,
                                          child: Icon(Icons.mood,
                                              size: 48, color: Colors.orange),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 120,
                                          child: Icon(Icons.mood,
                                              size: 48, color: Colors.yellow),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 150,
                                          child: Icon(Icons.mood,
                                              size: 48, color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                      width: 200,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  'You, Reggie, Sarah, Anne, Clara, Jane, and John all said ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Tennis',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )),
                                  SizedBox(height: 10),
                                  Center(
                                      child: Container(
                                    width: 100,
                                    height: 55,
                                    child: Stack(
                                      children: [
                                        Icon(Icons.mood,
                                            size: 55, color: Colors.orange),
                                        Positioned(
                                          top: 0,
                                          left: 30,
                                          child: Icon(Icons.mood,
                                              size: 55, color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  )),
                                  SizedBox(height: 10),
                                  Container(
                                      width: 220,
                                      child: Center(
                                          child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  'You were most similar to Sarah today, with a ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '97%',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                                text: ' similarity score!',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                )),
                                          ],
                                        ),
                                      ))),
                                  SizedBox(height: 20.0),
                                  Container(
                                    width: 220,
                                    child: Center(
                                      child: Text(
                                        'New Challenge in 13:04:16',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !response,
                    child: Image.asset(
                      'assets/bird.png',
                      width: 83,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        drawer: SideBar(username: widget.username),
      ),
    );
  }
}
