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

// my group is a page populated by the group-specific information
// it takes a ton of information...

/* Create Group:

frontend sends groupname, creator Username and added Usernames to the backend 

Backend returns the groupID, active challenges and groupMembers. 

I give myGroup:
- groupname
- active challenges
- group members
- group ID

once in myGroup, myGroup uses the ID to get the group stats from backend


*/

// class GroupChallenge

// MAKE IT

//Future void function, get active challenges

Future<void> getActiveChallenges(int groupId) async {
  final url = Uri.parse(
      BackendService.getBackendUrl() + 'group/' + '$groupId/' + 'challenges');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print('this is data $data');
    List<dynamic> activeChallenges = data['groups'];
    print('this is activeChallenges $activeChallenges');
  }
}
// create standard challenge

Future<void> createStandardChallenge(String username, int groupId) async {
  final url =
      Uri.parse(BackendService.getBackendUrl() + 'createStandardChallenge');
  final headers = <String, String>{'Content-Type': 'application/json'};
}

List<String> groupUsers = ['frances', '2', '2', '3', '33', '44'];

Future<void> preloadImages(BuildContext context) async {
  for (int i = 0; i < min(groupUsers!.length + 1, 6); i++) {
    final key = 'assets/Ellipse ${41 + i}.png';
    final image = AssetImage(key);
    await precacheImage(image, context);
  }
}

List<String> activeChallenges = [
  "Dahlia's Challenge",
  "Eve's Challenge",
  "Jackie's Challenge",
];

Future<void> _showChallengeOptions(
    BuildContext context, String groupName, int? groupId) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 200,
          height: 230,
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
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(8),
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
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // if groupname is a certain length, make it a new line
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                      context,
                      'Standard',
                      'Leave the categories to us',
                      Icons.my_library_books_rounded,
                      groupName,
                      groupId),
                  _buildOptionButton(
                      context,
                      'Custom',
                      'Create your own categories',
                      Icons.card_giftcard_rounded,
                      groupName,
                      groupId),
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
    IconData iconData, String groupName, int? groupId) {
  double number = 125.h;
  print(number);
  return Container(
      constraints: BoxConstraints(
          minWidth: 80.0, maxWidth: 150.0, minHeight: 80.0, maxHeight: 150.0),
      width: 125,
      height: 125,
      padding: EdgeInsets.all(10),
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
            activeChallenges.add('New Standard Challenge');

            Navigator.pop(context);

            //
          } else if (title == 'Custom') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    customChallenge(groupName: groupName, groupId: groupId),
              ),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Icon(
              iconData,
              color: Color.fromARGB(255, 250, 192, 94),
              size: 20,
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFFFFF7EE),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFF7EE),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ));
}

class myGroup extends StatefulWidget {
  final String groupName;
  final int? groupId;
  final List<String>? addedUsernames;

  myGroup({
    Key? key,
    this.addedUsernames,
    required this.groupName,
    required this.groupId,
  }) : super(key: key);

  @override
  _MyGroupState createState() => _MyGroupState();
}

class _MyGroupState extends State<myGroup> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget build(BuildContext context) {
    int groupID = 0;
    if (widget.groupId != null) {
      groupID = widget.groupId!;
    }

    getActiveChallenges(groupID);
    final String assetName = 'assets/img1.svg';
    List<String>? addedUsernames = widget.addedUsernames;

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
                        height: 260,
                        width: double.maxFinite,
                        child: Stack(alignment: Alignment.topCenter, children: [
                          // orange background
                          Container(
                            height: 240,
                            width: double.maxFinite,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              assetName,
                              fit: BoxFit.fill,
                            ),
                          ),
                          // app bar on top of background - currently non functional
                          CustomAppBar(),
                          Container(
                            margin: EdgeInsets.only(top: 80.v),
                            child: Column(
                              children: [
                                Text(
                                  widget.groupName,
                                  style: TextStyle(
                                    fontSize: 27,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 10.v),
                                Center(
                                  child: Container(
                                    width: min(groupUsers.length + 1, 6) * 60,
                                    height: 45,
                                    child: Stack(
                                      children: [
                                        for (int i = 0;
                                            i < min(groupUsers!.length + 1, 6);
                                            i++)
                                          Positioned(
                                            top: 0,
                                            left: 118.0 + (i * 20),
                                            child: Image.asset(
                                              'assets/Ellipse ${41 + i}.png',
                                              height: 30,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ])),
                  ]),
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
                              color: const Color.fromARGB(255, 117, 19, 12)
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
                                    indicatorSize: TabBarIndicatorSize.label,
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
                                            itemCount: activeChallenges.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          groupChallenge(
                                                              groupName: widget
                                                                  .groupName,
                                                              groupId: widget
                                                                  .groupId),
                                                    ),
                                                  );
                                                  print(
                                                      "Pressed ${activeChallenges[index]}");
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255 - (3 * index),
                                                        231 + index,
                                                        111 + (5 * index),
                                                        81 + (5 * index)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        activeChallenges[index],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.white,
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
                                            _showChallengeOptions(
                                                context,
                                                widget.groupName,
                                                widget.groupId);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Make Group Challenge',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFE76F51),
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
            child: Center(
              child: Text(
                'Most Similar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
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
                'Jackie and Erik',
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
