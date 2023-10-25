import 'package:flutter/material.dart';
import 'sideBar.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class globalChallenge extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  globalChallenge({
    Key? key,
    required this.username,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _GlobalChallengeState createState() => _GlobalChallengeState();

  void setState(Null Function() param0) {}
}

class _GlobalChallengeState extends State<globalChallenge> {
  String userResponse = '';
  List<String> userResponses = [];
  TextEditingController responseController = TextEditingController();
  String question1 = "";
  String question2 = "";
  String question3 = "";
  // Test method to print the passed-in user info from log-in page
  void printUserInfo() {
    print('Email in gb: ${widget.email}, Password in gb: ${widget.password}');
  }

  bool response = false;
  List<String> responses = List.filled(3, "");
  String fetch_questions = "";
  int currentQuestionIndex = 0;
  List<String> questions = ["", "", ""];

  Future<void> _fetchData() async {
    final fetch_questions = await http
        .get(Uri.parse('http://localhost:8080/api/v1/globalChallenge'));

    if (fetch_questions.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(fetch_questions.body);

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
    // This will fetch data when the widget is first created.
  }

  Future<void> sendUserResponses(List<String> userResponses) async {
    final url = Uri.parse('http://localhost:8080/api/v1/globalChallenge');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({'responses': userResponses}),
    );

    if (response.statusCode == 200) {
      print('Responses sent successfully');
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    List<String> questions = [question1, question2, question3];

    return Scaffold(
      //Constant features: Title, sidebar, alarm icon

      //Title: Verbatim

      appBar: AppBar(
        title: Container(
          height: 50,
          width: 220,
          alignment: Alignment(-2.0, 0.0),
          child: Image.asset('assets/Logo.png', fit: BoxFit.contain),
        ),

        //left hand corner: alarm icon
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_alert),
            onPressed: () {},
          ),
        ],
        centerTitle: false,
      ),

      //Sidebar implemented from sideBar.dart
      drawer: SideBar(),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            //Global Challenge # --> eventually pull in from backend
            Text(
              'Global Challenge #17',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Tab controller: 'Play' and 'Global Stats'
            Container(
              height: (500 *
                  (screenHeight /
                      650)), // amateur attempt at screen responsivity - will update later
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: TabBar(
                        indicatorColor: Colors.black,
                        labelColor: Colors.black,
                        tabs: [
                          Tab(text: 'Play'),
                          Tab(text: 'Global Stats'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: TabBarView(
                        children: [
                          // PLAY TAB
                          Center(
                            child: (response && currentQuestionIndex == 2)

                                // if a response has been submitted;
                                ? Column(
                                    children: [
                                      SizedBox(height: 30.0),

                                      SizedBox(height: 7.0),
                                      Text(
                                        '17,213 users have played',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 25.0),

                                      // user's response
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'You said: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: userResponses.join(
                                                  ' '), // Join the list elements with a space
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      SizedBox(
                                          height: 15.0 * (screenHeight / 300)),

                                      Center(
                                        child: Container(
                                          width: 200,
                                          height: 50,
                                          color: Color.fromARGB(
                                              255, 233, 229, 229),
                                          child: Center(
                                              child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Darrel Johnson',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '\nand 4 others have played',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        'New Category in 13:04:16',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )

                                // if a response has NOT been submitted
                                : Column(
                                    children: [
                                      SizedBox(
                                          height: 90.0 *
                                              pow((screenHeight / 1000), 2)),
                                      Text(
                                        questions[currentQuestionIndex],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '17,213 users have played',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 25.0),
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
                                      SizedBox(
                                          height: 15.0 * (screenHeight / 300)),
                                      Visibility(
                                        visible: !response,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                              255,
                                              22,
                                              93,
                                              151,
                                            ),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              userResponse =
                                                  responseController.text;
                                              userResponses.add(userResponse);
                                              responseController.clear();
                                              if (currentQuestionIndex <= 1) {
                                                // If not the last question, go to the next question.
                                                currentQuestionIndex += 1;
                                              } else {
                                                // If the last question, set 'response' to true to submit.
                                                setState(() {
                                                  response = true;
                                                  //sendUserResponses(
                                                  //    userResponses);
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
                                      ),
                                      SizedBox(
                                          height: 90.0 *
                                              pow((screenHeight / 1000), 2)),
                                      Center(
                                        child: Container(
                                          width: 200,
                                          height: 50,
                                          color: Color.fromARGB(
                                              255, 233, 229, 229),
                                          child: Center(
                                              child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Darrel Johnson',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '\nand 4 others have played',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 90.0 *
                                              pow((screenHeight / 1000), 2)),
                                      Text(
                                        'New Category in 13:04:16',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),

                          // GLOBAL STATS TAB
                          Center(
                              child: response
                                  // if a response HAS been submitted: you can see global stats
                                  ? Column(
                                      children: [
                                        SizedBox(height: 15.0),
                                        Text(
                                          question1,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 7.0),
                                        Text(
                                          '17,213 users have played',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 20.0),

                                        // scrollable - maybe play should be scrollable too?
                                        Expanded(
                                          child: CustomScrollView(
                                            slivers: <Widget>[
                                              SliverToBoxAdapter(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Most Popular Answers',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 250,
                                                      child: PieChart(
                                                        PieChartData(
                                                          centerSpaceRadius: 0,
                                                          sections: [
                                                            PieChartSectionData(
                                                              value: 30,
                                                              color: Colors.red,
                                                              title: 'Tennis',
                                                              badgePositionPercentageOffset:
                                                                  1.5,
                                                              radius: 120,
                                                            ),
                                                            PieChartSectionData(
                                                              value: 20,
                                                              color:
                                                                  Colors.green,
                                                              title:
                                                                  'Taekwondo',
                                                              badgePositionPercentageOffset:
                                                                  1.5,
                                                              radius: 120,
                                                            ),
                                                            PieChartSectionData(
                                                              value: 25,
                                                              color:
                                                                  Colors.blue,
                                                              title:
                                                                  'Table Tennis ',
                                                              badgePositionPercentageOffset:
                                                                  1.5,
                                                              radius: 120,
                                                            ),
                                                            PieChartSectionData(
                                                              value: 20,
                                                              color:
                                                                  Colors.yellow,
                                                              title:
                                                                  'Tag Football',
                                                              badgePositionPercentageOffset:
                                                                  .2,
                                                              radius: 120,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SliverToBoxAdapter(
                                                child: Center(
                                                  child: Text(
                                                    "Friends' Answers",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SliverGrid(
                                                gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200.0,
                                                  mainAxisSpacing: 10.0,
                                                  crossAxisSpacing: 10.0,
                                                  childAspectRatio: 4.0,
                                                ),
                                                delegate:
                                                    SliverChildBuilderDelegate(
                                                  (BuildContext context,
                                                      int index) {
                                                    return Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 50,
                                                      child:
                                                          Text('Name $index'),
                                                    );
                                                  },
                                                  childCount: 10,
                                                ),
                                              ),
                                              SliverToBoxAdapter(
                                                child: Center(
                                                  child: Text(
                                                    "New Category in 13:04:16",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  // if a response has not been submitted, global stats are blocked
                                  : Text(
                                      'You need to submit a response to view Global States')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
