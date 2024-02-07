import 'dart:async';

import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/customChallenge.dart';
import 'package:verbatim_frontend/screens/groupChallenge.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

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

//group stats variables
  double groupRating = 0;
  List<String> verbaMatchGroup = [];
  List<String> groupMembers = [];

  Future<void> getGroupStats(int groupId) async {
    final url =
        Uri.parse(BackendService.getBackendUrl() + 'group/' + '$groupId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      print("this is groupstats json code $jsonData");
      double rating = jsonData["groupRating"];
      print("this is the rating in mygroup $rating");
      groupRating = rating;

      List<dynamic> verbaMatchList = jsonData["verbaMatch"];
      List<String> usernames = [];
      for (var item in verbaMatchList) {
        usernames.add(item["username"]);
      }
      verbaMatchGroup = usernames;

      groupMembers = List<String>.from(jsonData["groupMembers"]);
    } else {
      print('failed to get group stats. Status code: ${response.statusCode}');
    }
  }

  Future<void> leaveGroup(int groupId, String username) async {
    final url = Uri.parse(BackendService.getBackendUrl() + 'leaveGroup');
    final headers = <String, String>{'Content-Type': 'application/json'};

    final response = await http.post(url,
        headers: headers,
        body: json.encode(({'groupId': groupId, 'username': username})));
    if (response.statusCode == 200) {
    } else {
      print("failure");
    }
  }

  List<Map<String, dynamic>> activeChallenges = [];
  Map<int, Map<String, dynamic>> challengeStats = {}; //jadded
  List<int> activeChallengeIds = [];
  Map<int, List<String>> mappedChallenges = {};
  List<String> titles = [];
  List<String> contentList = [];
  Map<int, List<String>> getChallengeMappedChallenges = {};

  Future<void> getActiveChallenges(int groupId) async {
    final url = Uri.parse(
        BackendService.getBackendUrl() + 'group/' + '$groupId/' + 'challenges');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey("activeChallenges") &&
          jsonData["activeChallenges"] is List) {
        activeChallenges =
            List<Map<String, dynamic>>.from(jsonData["activeChallenges"]);

        activeChallengeIds = activeChallenges
            .map((challenge) => challenge["id"] as int)
            .toList();

        mappedChallenges = getMappedChallenges(activeChallenges);
        challengeStats = Map.fromIterable(
          //jadded
          activeChallengeIds,
          key: (id) => id,
          value: (_) => {},
        );
      } else {}
    } else {
      print("active challenges not obtained succesfuly");
    }
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

//jadded
  List<dynamic> groupAnswers = [];
  double verbaMatchSimilarity = 0;
  int totalResponses = 0;

  Future<void> getChallenge(
      int challengeId,
      String user,
      Map<int, List<String>> mappedChallenges,
      Map<int, Map<String, dynamic>> challengeStats) async {
    final url = Uri.parse(BackendService.getBackendUrl() +
        '$challengeId/' +
        '$user/' +
        'getChallengeQs');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      bool userHasCompleted = jsonData['userHasCompleted'];
      String completed = userHasCompleted.toString();
      mappedChallenges[challengeId]!.add(completed);

      if (completed == 'false') {
        List<dynamic> questionsList = jsonData['questions'];
        for (List<dynamic> questionList in questionsList) {
          List<String> contentList = questionList
              .map<String>((item) => item['content'].toString())
              .toList();

          //put this question in mapped Challenges
          if (mappedChallenges.containsKey(challengeId)) {
            mappedChallenges[challengeId]!.addAll(contentList);
          } else {
            print('total failure');
          }
        }
      } else {
        // user HAS completed the challenge

        groupAnswers = jsonData['groupAnswers'];
        totalResponses = jsonData['totalResponses'];
        print(
            "this is json data check what verbamatch type is in getChallenge group $jsonData");
        List<dynamic> verbaMatch = jsonData['verbaMatch'];
        //double?
        verbaMatchSimilarity = jsonData['verbaMatchSimilarity'];
        Map<String, dynamic> groupAnswersMap = {"groupAnswers": groupAnswers};
        Map<String, int> totalResponsesMap = {"totalResponses": totalResponses};
        Map<String, double> verbaMatchSimilarityMap = {
          "verbaMatchSimilarity": verbaMatchSimilarity
        };
        Map<String, List<dynamic>> verbaMatchMap = {
          "verbaMatchUsers": verbaMatch
        };

        if (challengeStats.containsKey(challengeId)) {
          challengeStats[challengeId]!.addAll(groupAnswersMap);
          challengeStats[challengeId]!.addAll(totalResponsesMap);
          challengeStats[challengeId]!.addAll(verbaMatchSimilarityMap);
          challengeStats[challengeId]!.addAll(verbaMatchMap);
        } else {
          print("didnt happen ");
        }
      }
    } else {}
  }

// create standard challenge

  Future<void> createStandardChallenge(String username, int groupId) async {
    final url =
        Uri.parse(BackendService.getBackendUrl() + 'createStandardChallenge');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: json.encode({'createdByUsername': username, 'groupId': groupId}));
    if (response.statusCode == 200) {
    } else {
      print(
          'the standard chalfailed to crealenge. Status code: ${response.statusCode}');
    }
  }

  List<String> groupUsers = ['frances', '2', '2', '3', '33', '44'];

  Future<void> preloadImages(BuildContext context) async {
    for (int i = 0; i < min(groupUsers!.length + 1, 6); i++) {
      final key = 'assets/Ellipse ${41 + i}.png';
      final image = AssetImage(key);
      await precacheImage(image, context);
    }
  }

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
              int groupID = groupId!;
              //   activeChallengesHard.add('New Standard Challenge');

              Navigator.pop(context);
              String username = SharedPrefs().getUserName() ?? "";

              createStandardChallenge(username, groupID).then((_) {
                // re-initiate to load
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => myGroup(
                      groupName: groupName,
                      groupId: groupId,
                    ),
                  ),
                );
              });

              //
            } else if (title == 'Custom') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => customChallenge(
                    groupName: groupName,
                    groupId: groupId,
                    friendship: false,
                  ),
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    await getGroupStats(widget.groupId ?? 0);
    await getActiveChallenges(widget.groupId ?? 0);

    String username = SharedPrefs().getUserName() ?? "";

    for (var challengeId in activeChallengeIds) {
      await getChallenge(
          challengeId, username, mappedChallenges, challengeStats);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    // getGroupStats(widget.groupId ?? 0);
    final String assetName = 'assets/img1.svg';
    List<String>? addedUsernames = widget.addedUsernames;
    int groupID = widget.groupId!;
    String username = SharedPrefs().getUserName() ?? "";

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
                            margin: EdgeInsets.only(top: 70),
                            child: Column(
                              children: [
                                Text(
                                  widget.groupName,
                                  style: TextStyle(
                                    fontSize: 30,
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
                                ),
                                Center(
                                    child: Container(
                                        margin: EdgeInsets.only(top: 13),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    leaveGroup(
                                                        groupID, username);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                  ),
                                                  child: Text("Leave Group",
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFE76F51),
                                                      ))),
                                            ])))
                              ],
                            ),
                          ),
                        ])),
                  ]),
                ),
                Center(
                    child: Container(
                        clipBehavior: Clip.hardEdge,
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
                                            itemCount: mappedChallenges.length,
                                            itemBuilder: (context, index) {
                                              int id = mappedChallenges.keys
                                                  .elementAt(index);
                                              List<String> challengeInfo =
                                                  mappedChallenges[id]!;
                                              String createdByUsername =
                                                  challengeInfo[0];

                                              String challengeType =
                                                  challengeInfo[1] == "Custom"
                                                      ? "custom"
                                                      : "standard";

                                              String challengeInfo2 =
                                                  challengeInfo[2];

                                              // if challengeInfo[2] is false they have not completed

                                              bool completed =
                                                  (challengeInfo2 != "false");
                                              // if challengeInfo2 is true, they have completed
                                              // if not, completed is false.
                                              // initialize stats variables
                                              double verbaMatchStats = 0;
                                              int totalResponsesStats = 0;
                                              List<dynamic> groupAnswersStats =
                                                  [];
                                              List<dynamic>
                                                  verbaMatchUsersStats = [];

                                              if (completed) {
                                                verbaMatchUsersStats =
                                                    challengeStats[id]![
                                                        'verbaMatchUsers'];
                                                groupAnswersStats =
                                                    challengeStats[id]![
                                                        'groupAnswers'];

                                                verbaMatchStats =
                                                    challengeStats[id]![
                                                        'verbaMatchSimilarity'];

                                                totalResponsesStats =
                                                    challengeStats[id]![
                                                        'totalResponses'];
                                              }
                                              List<dynamic> questions2 =
                                                  groupAnswersStats
                                                      .map((entry) =>
                                                          entry['question'])
                                                      .toList();
                                              List<String> questionList =
                                                  questions2
                                                      .map((dynamic value) =>
                                                          value.toString())
                                                      .toList();

                                              List<String> challengeQuestions =
                                                  challengeInfo
                                                      .skip(3)
                                                      .toList();

                                              String title =
                                                  "$createdByUsername's $challengeType challenge";

                                              return GestureDetector(
                                                onTap: () {
                                                  if (!completed) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            groupChallenge(
                                                          groupName:
                                                              widget.groupName,
                                                          groupId: groupID,
                                                          challengeQs:
                                                              challengeQuestions,
                                                          challengeId: id,
                                                          completed: false,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              groupChallenge(
                                                                groupName: widget
                                                                    .groupName,
                                                                groupId: widget
                                                                    .groupId,
                                                                challengeQs:
                                                                    questionList,
                                                                challengeId: id,
                                                                completed: true,
                                                                groupAnswers:
                                                                    groupAnswersStats,
                                                                verbaMatchSimilarity:
                                                                    verbaMatchStats,
                                                                totalResponses:
                                                                    totalResponsesStats,
                                                                verbaMatchUsers:
                                                                    verbaMatchUsersStats,
                                                              )),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 231, 111, 81),
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
                                                        title,
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
                                  Container(
                                      child: StatsContent(
                                          verbaMatchStatsContent:
                                              verbaMatchGroup,
                                          groupRating: groupRating)),
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
  List<String> verbaMatchStatsContent;
  double groupRating;

  StatsContent({
    required this.verbaMatchStatsContent,
    required this.groupRating,
  });

  @override
  Widget build(BuildContext context) {
    print("this is grouprating in groups stats content $groupRating");
    String verb1 = verbaMatchStatsContent[0];
    String verb2 = verbaMatchStatsContent[1];

    print(
        "this is verbamatch in groups stats content $String verb1 = verbaMatchStatsContent[0];");
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // color: Colors.white,
            height: 200,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: DonutChart(
                  groupSimilarity: groupRating, title: 'Group Power Score'),
            ),
          ),
          SizedBox(height: 15.v),
          Visibility(
            visible: verbaMatchStatsContent.length != 0,
            child: Container(
              child: Center(
                child: Text(
                  'Most Similar: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
              visible: verbaMatchStatsContent.length == 0,
              child: Container(
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'No ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Verba-',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Matches...',
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
              )),
          Visibility(
            visible: verbaMatchStatsContent.isEmpty,
            child: SizedBox(
              height: 20,
            ),
          ),
          Visibility(
            visible: verbaMatchStatsContent.isEmpty,
            child: Container(
              child: Center(
                child: Text(
                  'Play more challenges to match!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: verbaMatchStatsContent.length != 0,
            child: Container(
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
          ),
          Visibility(
            visible: verbaMatchStatsContent.length != 0,
            child: Container(
              child: Center(
                child: Text(
                  'hardcoded% Similarity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: verbaMatchStatsContent.length != 0,
            child: SizedBox(height: 10.v),
          ),
          Visibility(
            visible: verbaMatchStatsContent.length != 0,
            child: Center(
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
          ),
          Visibility(
            visible: verbaMatchStatsContent.length != 0,
            child: SizedBox(height: 15.v),
          ),
          Visibility(
            visible: verbaMatchStatsContent.length != 0,
            child: Container(
              child: Center(
                child: Text(
                  '$verb1 and $verb2',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
  Future<void> _showPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
              width: 160,
              height: 145,
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
                    padding: EdgeInsets.all(6),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Your score increases when you:\n\n',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // if groupname is a certain length, make it a new line
                          TextSpan(
                            text:
                                'Verbatim, Build Streaks, and Play Challenges!',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color calculateColor(double similarity) {
      int score = (similarity / 2).toInt();

      return Color.fromARGB(255, 250, 192 + score, 94 + score);
    }

    double sim = widget.groupSimilarity;
    int simint = sim as int;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            InkWell(
              onTap: () => _showPopup(context),
              child: Icon(
                Icons.help_outline,
                color: Color(0xFFE76F51),
              ),
            )
          ]),
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
                                "${simint.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Rating",
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
