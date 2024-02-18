import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/gameObject.dart';
import 'sideBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/custom_tab.dart';
import 'dart:async';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:intl/intl.dart';
import 'globalSubmitGuest.dart';

class guestGlobal extends StatefulWidget {
  const guestGlobal({
    Key? key,
  }) : super(key: key);

  @override
  _GuestGlobalState createState() => _GuestGlobalState();
}

class _GuestGlobalState extends State<guestGlobal> {
  String username = SharedPrefs().getUserName() ?? "";
  List<String> userResponses = ['', '', '', '', ''];
  String userResponse = '';
  List<String> responses123 = [];

  TextEditingController responseController = TextEditingController();

  List<String> questions = ["", "", "", "", ""];
  String question1 = "";
  String question2 = "";
  String question3 = "";
  String question4 = "";
  String question5 = "";

  String categoryQ1 = "";
  String categoryQ2 = "";
  String categoryQ3 = "";
  String categoryQ4 = "";
  String categoryQ5 = "";
  int id = 0;

  // bool responded = false;
  double progressValue = 0.0;
  int currQIdx = 0;
  int totalResponses = 0;

  final StreamController<bool> _streamController = StreamController<bool>();

  Future<void> _fecthNoSignInData() async {
    final url =
        Uri.parse("${BackendService.getBackendUrl()}globalChallengeNoSignIn");
    final headers = <String, String>{'Content-Type': 'application/json'};
    final fetchQuestions = await http.get(url, headers: headers);
    print("Before getting qs with no username");

    if (fetchQuestions.statusCode == 200) {
      print("what is she?${fetchQuestions.body}");
      final Map<String, dynamic>? data = json.decode(fetchQuestions.body);

      id = data!['globalChallengeId'];

      question1 = data['q1'];
      question2 = data['q2'];
      question3 = data['q3'];
      question4 = data['q4'];
      question5 = data['q5'];

      categoryQ1 = data['categoryQ1'];
      categoryQ2 = data['categoryQ2'];
      categoryQ3 = data['categoryQ3'];
      categoryQ4 = data['categoryQ4'];
      categoryQ5 = data['categoryQ5'];

      // totalResponses = data['totalResponses'];
    }
  }

  @override
  void initState() {
    super.initState();
    if (username == '') {
      _fecthNoSignInData().then((_) {
        setState(() {
          questions = [question1, question2, question3, question4, question5];
        });
      });
    } else {
      print(
          "Username present, cannot perform guest operations with signed in User");
    }
  }

  void parseResponses() {
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

//make sure we can send responses to stats on the first go
    responses123 = modifiedResponses;
  }

  void setGuestUserResponses() {
    parseResponses();
    SharedPrefs().updateGameValues(responses123[0], responses123[1],
        responses123[2], responses123[3], responses123[4]);

       responseQ1 = responses123[0];
      responseQ2 = responses123[1];
      responseQ3 = responses123[2];
      responseQ4 = responses123[3];
      responseQ5 = responses123[4];
    // setState(() {
    //   responseQ1 = responses123[0];
    //   responseQ2 = responses123[1];
    //   responseQ3 = responses123[2];
    //   responseQ4 = responses123[3];
    //   responseQ5 = responses123[4];
    // });
    // setState(() {
    //   GameObject.responseQ2 = responses123[1];
    // });
    // setState(() {
    //   GameObject.responseQ3 = responses123[2];
    // });
    // setState(() {
    //   GameObject.responseQ4 = responses123[3];
    // });
    // setState(() {
    //   GameObject.responseQ5 = responses123[4];
    // });
  }

  void updateProgress() {
    setState(() {
      progressValue = (currQIdx + 1) / questions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    String idString = id.toString();
    username = SharedPrefs().getUserName() ?? "";

    //get time and format
    DateTime now = DateTime.now();
    DateTime midnight =
        DateTime(now.year, now.month, now.day + 1); // Set to next midnight
    Duration timeUntilMidnight = midnight.difference(now);
    String formattedTimeUntilMidnight =
        DateFormat.Hms().format(DateTime(0).add(timeUntilMidnight));

    const String assetName = 'assets/img1.svg';
    List<String> tabLables = [
      categoryQ1,
      categoryQ2,
      categoryQ3,
      categoryQ4,
      categoryQ5
    ];

    bool showText = true;
    updateProgress();

    void toggleTextVisibility() {
      _streamController.sink.add(!showText);
      showText = !showText;
    }
    print("In Guest Global, username: "+ username +" ,responded: " +responded.toString());
    return SafeArea(
    
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(255, 255, 243, 238),
        body: SingleChildScrollView(
          child: Container(
              color: const Color.fromARGB(255, 255, 243, 238),
              child: Column(
                children: [
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
                            Center(
                              child: Container(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'Global Challenge #$idString',
                                  style: const TextStyle(
                                    fontSize: 27,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                                child: Container(
                                    padding: const EdgeInsets.only(top: 170),
                                    child: SizedBox(
                                        height: 40,
                                        width: double.maxFinite,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              child: RichText(
                                                text: const TextSpan(
                                                  //TODO:
                                                  children: [
                                                    TextSpan(
                                                      text: 'TBD',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            " users have played today",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: 50,
                                                width: 150,
                                                child: Container(
                                                  child: PlayTab(
                                                    onTabSelectionChanged: (bool
                                                        isFirstTabSelected) {
                                                      toggleTextVisibility();
                                                    },
                                                  ),
                                                ))
                                          ],
                                        ))))
                          ])),
                    ]),
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.only(top: 10.v),
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
                              offset: const Offset(3, 7),
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
                                        const SizedBox(height: 30),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text(
                                            questions[currQIdx],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30.0),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: TextField(
                                            controller: responseController,
                                            onChanged: (value) {
                                              setState(() {
                                                if (currQIdx < 5) {
                                                  userResponses[currQIdx] =
                                                      value;
                                                }
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Type your answer here...',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 40.0),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFE76F51),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            minimumSize: const Size(150, 40),
                                            padding: const EdgeInsets.all(16),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (currQIdx < 4) {
                                                userResponses[currQIdx] =
                                                    responseController.text;
                                                responseController.clear();
                                                updateProgress();
                                                currQIdx += 1;
                                              } else {
                                                //setGuestUserResponses();
                                                setState(() {
                                                  responded = true;
                                                });
                                              }
                                            });
                                          },
                                          child: Text(
                                            currQIdx == 4 ? 'Submit' : 'Next',
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: 200,
                                          child: LinearProgressIndicator(
                                            value: progressValue,
                                            backgroundColor: Colors.grey[300],
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Color(0xFFE76F51)),
                                            minHeight: 10,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (responded == false) {
                                    return const Column(
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
                                                  color: Color(0xFFE76F51),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'challenge',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFE76F51),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'to see ',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFE76F51),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'Global Stats!',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFE76F51),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                  //if guest
                                  else if (username == '' &&
                                      responded == true) {
                                    // setState(() {
                                    //   responded = true;
                                    // });
                                    setGuestUserResponses();

                                    return Column(
                                      children: [
                                        Guest(
                                          formattedTimeUntilMidnight:
                                              formattedTimeUntilMidnight,
                                        ),
                                      ],
                                    );
                                  }
                                  //NEED TO CHANGE THIS SNIPPET OF CODE TO HAVE THE CARD AND A SIGN UP
                                  else {
                                    return Column(
                                      children: [
                                        Guest(
                                            formattedTimeUntilMidnight:
                                                formattedTimeUntilMidnight),
                                      ],
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !responded,
                        child: Image.asset(
                          'assets/bird.png',
                          width: 90,
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
        drawer: const SideBar(),
      ),
    );
  }
}
