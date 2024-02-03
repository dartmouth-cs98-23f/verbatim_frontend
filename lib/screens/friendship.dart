import 'dart:async';

import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/customChallenge.dart';
import 'package:verbatim_frontend/screens/groupChallenge.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/create_group_app_bar.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

List<Map<String, dynamic>> activeChallenges = [];
List<int> activeChallengeIds = [];
Map<int, List<String>> mappedChallenges = {};
List<String> titles = [];
List<String> contentList = [];
Map<int, List<String>> getChallengeMappedChallenges = {};

// but version for friends
Future<void> getActiveChallenges(String user, String friend) async {
  final url = Uri.parse(
      BackendService.getBackendUrl() + '$user/' + '$friend/' + 'challenges');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final dynamic jsonData = json.decode(response.body);
    print(jsonData);

    if (jsonData is Map<String, dynamic> &&
        jsonData.containsKey("activeChallenges") &&
        jsonData["activeChallenges"] is List) {
      activeChallenges =
          List<Map<String, dynamic>>.from(jsonData["activeChallenges"]);

      activeChallengeIds =
          activeChallenges.map((challenge) => challenge["id"] as int).toList();

      mappedChallenges = getMappedChallenges(activeChallenges);
      print('$activeChallenges');
    } else {}
  } else {}
}

Map<int, List<String>> getMappedChallenges(List<dynamic> activeChallenges) {
  Map<int, List<String>> mappedChallenges = {};

  for (var challenge in activeChallenges) {
    int id = challenge["id"];
    String createdByUsername = challenge["createdBy"]["username"];
    bool isCustom = challenge["isCustom"];

    List<String> challengeInfo = [
      createdByUsername,
      isCustom ? "Custom" : "Not Custom"
    ];
    mappedChallenges[id] = challengeInfo;
  }

  return mappedChallenges;
}

Future<void> getChallenge(
    int challengeId, Map<int, List<String>> mappedChallenges) async {
  final url = Uri.parse(BackendService.getBackendUrl() + 'getChallengeQs');
  final headers = <String, String>{'Content-Type': 'application/json'};

  final response = await http.post(url,
      headers: headers,
      body: json.encode(
        challengeId,
      ));
  if (response.statusCode == 200) {
    final dynamic jsonData = json.decode(response.body);
    if (jsonData is List) {
      contentList = jsonData.expand<String>((innerList) {
        return innerList.map<String>((item) {
          return item['content'].toString();
        });
      }).toList();

      if (mappedChallenges.containsKey(challengeId)) {
        mappedChallenges[challengeId]!.addAll(contentList);
      } else {
        print('total failure');
      }
      getChallengeMappedChallenges = mappedChallenges;
    } else {
      print("bad format");
    }
  } else {
    print(
        'failed to get challenge beeeeepp questions. Status code: ${response.statusCode}');
  }
}

Future<void> createStandardChallenge(String username, int groupId) async {
  final url =
      Uri.parse(BackendService.getBackendUrl() + 'createStandardChallenge');
  final headers = <String, String>{'Content-Type': 'application/json'};
  print('this is $username and this is groupId $groupId');
  final response = await http.post(url,
      headers: headers,
      body: json.encode({'createdByUsername': username, 'groupId': groupId}));
  if (response.statusCode == 200) {
  } else {
    print(
        'failed to create standard challenge. Status code: ${response.statusCode}');
  }
}

Future<void> _showChallengeOptions(
    BuildContext context, String groupName) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 250,
          height: 250,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF9E503C).withOpacity(0.5),
                blurRadius: 4,
                offset: Offset(2, 3),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.v),
              Padding(
                padding: EdgeInsets.all(8.v),
                child: Container(
                    child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'New Challenge with ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '$groupName',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ),
              SizedBox(height: 20.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                      context,
                      'Standard',
                      'Leave the categories to us',
                      Icons.my_library_books_rounded,
                      groupName),
                  _buildOptionButton(
                      context,
                      'Custom',
                      'Create your own categories',
                      Icons.card_giftcard_rounded,
                      groupName),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildOptionButton(BuildContext context, title, String description,
    IconData iconData, String groupName) {
  double number = 125.h;
  print(number);
  return Container(
      constraints: BoxConstraints(
          minWidth: 80.0, maxWidth: 150.0, minHeight: 80.0, maxHeight: 150.0),
      width: 125.h,
      height: 125.h,
      padding: EdgeInsets.all(10.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color(0xFFE76F51),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF997048).withOpacity(0.5),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          //talk to backend/add new popup - make something change so it pops up immediately
          // some bool that can automatically call set state from other widget?

          if (title == 'Standard') {
            String username = SharedPrefs().getUserName() ?? "";
//can't be -1
            createStandardChallenge(username, -1);

            Navigator.pop(context);

            //
          } else if (title == 'Custom') {
            // THIS IS A FAKE GROUP ID THIS NEEDS TO BE BETTER SO IT DOESNT MESS EVERYTHIGN UP
            // EACH FRIENDSHIP NEEDS A GROUP ID?

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    customChallenge(groupName: groupName, groupId: 1),
              ),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5.v),
            Icon(
              iconData,
              color: Color.fromARGB(255, 250, 192, 94),
              size: 35.v,
            ),
            SizedBox(height: 5.v),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFFFFF7EE),
                fontSize: 22.v,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 5.v),
            SizedBox(
              width: double.infinity,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFF7EE),
                  fontSize: 16.v,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ));
}

class friendship extends StatefulWidget {
  final String friendUsername;

  friendship({
    Key? key,
    required this.friendUsername,
  }) : super(key: key);

  @override
  _FriendshipState createState() => _FriendshipState();
}

class _FriendshipState extends State<friendship>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    String username = SharedPrefs().getUserName() ?? "";

    await getActiveChallenges(username, widget.friendUsername);

    for (var challengeId in activeChallengeIds) {
      await getChallenge(challengeId, mappedChallenges);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    final String assetName = 'assets/img1.svg';

    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 243, 238),
      body: SingleChildScrollView(
          child: Container(
              color: Color.fromARGB(255, 255, 243, 238),
              child: Column(children: [
                SizedBox(
                    width: double.maxFinite,
                    child: Column(children: [
                      SizedBox(
                        height: 200,
                        width: double.maxFinite,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              height: 200,
                              color: Colors.transparent,
                              width: double.maxFinite,
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              child: SvgPicture.asset(
                                assetName,
                                fit: BoxFit.fill,
                              ),
                            ),
                            CustomAppBar(),
                            Center(
                                child: Container(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Column(children: [
                                      Text(
                                        'You and ${widget.friendUsername}',
                                        style: TextStyle(
                                          fontSize: 27,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ])))
                          ],
                        ),
                      ),
                      Center(
                          child: Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.only(top: 10),
                              width: 340,
                              height: 450,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 117, 19, 12)
                                            .withOpacity(0.5),
                                    blurRadius: 5,
                                    offset: Offset(3, 7),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  DefaultTabController(
                                    length: 2,
                                    child: Column(
                                      children: [
                                        TabBar(
                                          unselectedLabelColor: Colors.black,
                                          controller: _tabController,
                                          indicatorColor: Color(0xFFE76F51),
                                          labelColor: Color(0xFFE76F51),
                                          indicatorPadding: EdgeInsets.zero,
                                          indicatorSize:
                                              TabBarIndicatorSize.label,
                                          tabs: [
                                            Tab(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Play",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Tab(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Group Stats",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        // Active Challenges
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              right: 10,
                                              left: 10,
                                              bottom: 20),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      mappedChallenges.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    int id = mappedChallenges
                                                        .keys
                                                        .elementAt(index);
                                                    List<String> challengeInfo =
                                                        mappedChallenges[id]!;
                                                    String createdByUsername =
                                                        challengeInfo[0];

                                                    String challengeType =
                                                        challengeInfo[1] ==
                                                                "Custom"
                                                            ? "custom"
                                                            : "standard";
                                                    List<String>
                                                        challengeQuestions =
                                                        challengeInfo
                                                            .skip(2)
                                                            .toList();

                                                    String title =
                                                        "$createdByUsername's $challengeType challenge";
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                groupChallenge(
                                                                    groupName:
                                                                        widget
                                                                            .friendUsername,
                                                                    groupId: -1,
                                                                    challengeQs:
                                                                        challengeQuestions,
                                                                    challengeId:
                                                                        id),
                                                          ),
                                                        );
                                                        print(
                                                            "Pressed ${activeChallenges[index]}");
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          vertical: 10,
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255 - (3 * index),
                                                              231 + index,
                                                              111 + (5 * index),
                                                              81 + (5 * index)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              title,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 10.v),
                                              GestureDetector(
                                                onTap: () {
                                                  _showChallengeOptions(context,
                                                      widget.friendUsername);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'New Challenge',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFE76F51),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(
                                                      Icons.add,
                                                      size: 20,
                                                      color: Color(0xFFE76F51),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Content for Stats
                                        Container(child: StatsContent()),
                                      ],
                                    ),
                                  ),
                                ],
                              )))
                    ]))
              ]))),
      drawer: SideBar(),
    ));
  }
}

class StatsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // color: Colors.white,
            height: 200,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child:
                  DonutChart(groupSimilarity: 30, title: 'Global Challenges'),
            ),
          ),
          SizedBox(height: 15.v),
          Container(
            height: 200,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: DonutChart(
                groupSimilarity: 60,
                title: 'Group Challenges',
              ),
            ),
          ),
          SizedBox(height: 20.v),
          Container(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Verba',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Match!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                '97% Similarity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          Center(
            child: Container(
              width: 170,
              height: 60,
              child: Stack(
                children: [
                  for (int i = 0; i < 2; i++)
                    Positioned(
                      top: 0,
                      left: 35.0 + (i * 50),
                      child: Image.asset(
                        'assets/Ellipse ${41 + i}.png',
                        height: 60,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.v),
          Container(
            child: Center(
              child: Text(
                'Eve and Frances',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 50.v)
        ],
      ),
    );
  }
}

class DonutChart extends StatefulWidget {
  final double groupSimilarity;
  final String title;

  DonutChart({
    Key? key,
    required this.groupSimilarity,
    required this.title,
  }) : super(key: key);

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  @override
  Widget build(BuildContext context) {
    Color calculateColor(double similarity) {
      int score = similarity as int;
      score = (score / 2) as int;

      return Color.fromARGB(255, 250, 192 + score, 94 + score);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 17.v),
          SizedBox(
            height: 125,
            child: Stack(
              children: [
                PieChart(
                  //set the values of offset

                  PieChartData(
                    startDegreeOffset: 250,
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                    sections: [
                      PieChartSectionData(
                        value: widget.groupSimilarity,
                        color: Color(0xFFE76F51),
                        radius: 25,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 100 - widget.groupSimilarity,
                        color: calculateColor(widget.groupSimilarity),
                        radius: 16,
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
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 255, 243, 238),
                                blurRadius: 10.0,
                                spreadRadius: 10.0,
                                offset: const Offset(3, 3)),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${widget.groupSimilarity.toStringAsFixed(2)}%",
                                style: TextStyle(
                                  fontSize: 10,
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
    );
  }
}
