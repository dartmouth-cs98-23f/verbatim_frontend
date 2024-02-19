import 'dart:async';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/customChallenge.dart';
import 'package:verbatim_frontend/screens/groupChallenge.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:verbatim_frontend/widgets/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:fl_chart/fl_chart.dart';

class friendship extends StatefulWidget {
  final String friendUsername;

  const friendship({
    Key? key,
    required this.friendUsername,
  }) : super(key: key);

  @override
  _FriendshipState createState() => _FriendshipState();
}

class _FriendshipState extends State<friendship>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // variables for friendgroup Stats
  double groupRating = 0.0;
  List<dynamic> verbaMatch = [];
  List<String> groupMembers = [];

  // builds challenge option pop
  Future<void> _showChallengeOptions(
      BuildContext context, String groupName) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                20.0), // maybe this will fix weird looking border?
          ),
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          content: Container(
            width: 220,
            height: 230,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9E503C).withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(2, 3),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                      child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'New Challenge with ',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: groupName,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.orange,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  //builds the actual buttons themselves

  Widget _buildOptionButton(BuildContext context, title, String description,
      IconData iconData, String groupName) {
    return Container(
        width: 130,
        height: 130,
        padding: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFE76F51),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF997048).withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            //talk to backend/add new popup - make something change so it pops up immediately
            // some bool that can automatically call set state from other widget?

            if (title == 'Standard') {
              String username = SharedPrefs().getUserName() ?? "";

              Navigator.pop(context);
              createStandardChallenge(username, groupId).then((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => friendship(
                      friendUsername: groupName,
                    ),
                  ),
                );
              });

              //
            } else if (title == 'Custom') {
              // does this 'groupname' thing work?
              //shld i navigator.pop?
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => customChallenge(
                    groupName: groupName,
                    groupId: groupId,
                    friendship: true,
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
              const SizedBox(height: 5),
              Icon(
                iconData,
                color: const Color.fromARGB(255, 250, 192, 94),
                size: 20,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color(0xFFFFF7EE),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFFFFF7EE),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

// ask backend for stats between the two friends
  Future<void> getFriendStats(String user, String friend) async {
    final url = Uri.parse('${BackendService.getBackendUrl()}$user/$friend');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      print("\nthis is the jsonData from getFriendStats $jsonData\n");

      double rating = jsonData["groupRating"];
      groupRating = rating;

      // verbaMatch = List<String>.from(jsonData["verbaMatch"]);
      groupMembers = List<String>.from(jsonData["groupMembers"]);
      print(
          "In GetFriendStats this is the rating: $groupRating verbaMatch: $verbaMatch, groupmebers: $groupMembers");
    } else {
      print(
          'failed to get friendship stats. Status code: ${response.statusCode}');
    }
  }

//active challenge variables
  List<Map<String, dynamic>> activeChallenges = [];
  Map<int, Map<String, dynamic>> challengeStats = {};
  List<int> activeChallengeIds = [];
  Map<int, List<String>> mappedChallenges = {};
  List<String> titles = [];
  List<String> contentList = [];
  Map<int, List<String>> getChallengeMappedChallenges = {};
  int groupId = -1; // get from getActiveChallenge

// asks backend for active challenges between these friends
  Future<void> getActiveChallenges(String user, String friend) async {
    final url =
        Uri.parse('${BackendService.getBackendUrl()}$user/$friend/challenges');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey("activeChallenges") &&
          jsonData["activeChallenges"] is List) {
        activeChallenges =
            List<Map<String, dynamic>>.from(jsonData["activeChallenges"]);
        groupId = jsonData["groupId"];

        activeChallengeIds = activeChallenges
            .map((challenge) => challenge["id"] as int)
            .toList();

        mappedChallenges = getMappedChallenges(activeChallenges);
        challengeStats = {for (var id in activeChallengeIds) id: {}};
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

// challengeSTATS variables

  List<dynamic> groupAnswers = [];
  double verbaMatchSimilarity = 0.0;
  int totalResponses = 0;

  Future<void> getUserHasCompleted(int challengeId, String user) async {
    final url = Uri.parse(
        '${BackendService.getBackendUrl()}$challengeId/$user/userHasCompleted');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
    } else {
      print("failure");
    }
  }

  Future<void> getChallenge(
      int challengeId,
      String user,
      Map<int, List<String>> mappedChallenges,
      Map<int, Map<String, dynamic>> challengeStats) async {
    final url = Uri.parse(
        '${BackendService.getBackendUrl()}$challengeId/$user/getChallengeQs');

    // await getUserHasCompleted(challengeId, user);

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      bool userHasCompleted = jsonData['userHasCompleted'];
      String completed = userHasCompleted.toString();
      // put completion status in mapped challenges
      mappedChallenges[challengeId]!.add(completed);
      List<dynamic> map = mappedChallenges[challengeId]!;

// user has not completed the challenge
      if (completed == 'false') {
        List<dynamic> questionsList = jsonData['questions'];
        for (List<dynamic> questionList in questionsList) {
          List<String> contentList = questionList
              .map<String>((item) => item['content'].toString())
              .toList();

          //put the questions in mapped Challenges
          if (mappedChallenges.containsKey(challengeId)) {
            mappedChallenges[challengeId]!.addAll(contentList);
          } else {
            print('\n couldnt put questions in mapped challenges');
          }
        }
      } else // user HAS completed the challenge - fill in stats
      {
        // set up challenge stats
        verbaMatch = jsonData['verbaMatch'];
        groupAnswers = jsonData['groupAnswers'];
        totalResponses = jsonData['totalResponses'];
        // List<String> verbaMatch = jsonData['verbaMatch'];
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
    } else {
      print(
          'failed to get challenge beeeeepp questions. Status code: ${response.statusCode}');
    }
  }

  Future<void> createStandardChallenge(String username, int groupId) async {
    final url =
        Uri.parse('${BackendService.getBackendUrl()}createStandardChallenge');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final response = await http.post(url,
        headers: headers,
        body: json.encode({'createdByUsername': username, 'groupId': groupId}));
    if (response.statusCode == 200) {
    } else {
      print(
          'failed to create standard challenge. Status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadChallenges();
  }

  List<String> verbaMatchGroup = [];
  Future<void> _loadChallenges() async {
    String username = SharedPrefs().getUserName() ?? "";

    getFriendStats(username, widget.friendUsername);
    verbaMatchGroup = [username, widget.friendUsername];

    await getActiveChallenges(username, widget.friendUsername);

    for (var challengeId in activeChallengeIds) {
      //  print("here getting getChallenge for $challengeId");
      await getChallenge(
          challengeId, username, mappedChallenges, challengeStats);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/img1.svg';

    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 243, 238),
      body: SingleChildScrollView(
          child: Container(
              color: const Color.fromARGB(255, 255, 243, 238),
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
                            const CustomAppBar(),
                            Center(
                                child: Container(
                                    padding: const EdgeInsets.only(top: 100),
                                    child: Column(children: [
                                      Text(
                                        'You and ${widget.friendUsername.replaceFirstMapped(
                                          RegExp(r'^\w'),
                                          (match) => match
                                              .group(0)!
                                              .toUpperCase(), // Ensures the first letter of first name is capitalized.
                                        )}',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 27,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ])))
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                            clipBehavior: Clip.hardEdge,
                            margin: const EdgeInsets.only(top: 10),
                            width: 340,
                            height: 450,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 117, 19, 12)
                                      .withOpacity(0.5),
                                  blurRadius: 5,
                                  offset: const Offset(3, 7),
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
                                        indicatorColor: const Color(0xFFE76F51),
                                        labelColor: const Color(0xFFE76F51),
                                        indicatorPadding: EdgeInsets.zero,
                                        indicatorSize:
                                            TabBarIndicatorSize.label,
                                        tabs: [
                                          Tab(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Play",
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Tab(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Group Stats",
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
                                      Column(
                                        children: [
                                          Visibility(
                                              visible:
                                                  mappedChallenges.isEmpty,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    right: 10,
                                                    left: 10,
                                                    bottom: 20),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 40),
                                                    Image.asset(
                                                      'assets/bird3.png',
                                                      width: 240,
                                                    ),
                                                    const SizedBox(height: 35),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _showChallengeOptions(
                                                            context,
                                                            widget
                                                                .friendUsername);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            'New Challenge',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          const Icon(
                                                            Icons.add,
                                                            size: 20,
                                                            color: Colors.black,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Visibility(
                                              visible:
                                                  mappedChallenges.isNotEmpty,
                                              child: Container(
                                                height: 400,
                                                width: 330,
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    right: 10,
                                                    left: 10,
                                                    bottom: 20),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            mappedChallenges
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          int id =
                                                              mappedChallenges
                                                                  .keys
                                                                  .elementAt(
                                                                      index);
                                                          List<String>
                                                              challengeInfo =
                                                              mappedChallenges[
                                                                  id]!;
                                                          String
                                                              createdByUsername =
                                                              challengeInfo[0];

                                                          String challengeType =
                                                              challengeInfo[
                                                                          1] ==
                                                                      "Custom"
                                                                  ? "custom"
                                                                  : "standard";

                                                          // if challenge is completed, mark it as such
                                                          // it doesn't seem like the challenges are being marked as completed
                                                          String
                                                              challengeInfo2 =
                                                              challengeInfo[2];

                                                          bool completed =
                                                              (challengeInfo2 !=
                                                                  "false");

                                                          // initialize stats variables
                                                          List<dynamic>
                                                              verbaMatchUsersStats =
                                                              [];
                                                          double
                                                              verbaMatchStats =
                                                              0;
                                                          int totalResponsesStats =
                                                              0;
                                                          List<dynamic>
                                                              groupAnswersStats =
                                                              [];

                                                          if (completed) {
                                                            verbaMatchUsersStats =
                                                                challengeStats[
                                                                        id]![
                                                                    'verbaMatchUsers'];
                                                            groupAnswersStats =
                                                                challengeStats[
                                                                        id]![
                                                                    'groupAnswers'];

                                                            verbaMatchStats =
                                                                challengeStats[
                                                                        id]![
                                                                    'verbaMatchSimilarity'];

                                                            totalResponsesStats =
                                                                challengeStats[
                                                                        id]![
                                                                    'totalResponses'];
                                                            print(
                                                                "Challenge stats sent to backend: verbaMatchUsers: $verbaMatchUsersStats,\n  verbaMatchSimilarity: $verbaMatchSimilarity");
                                                          }

                                                          List<dynamic>
                                                              questions2 =
                                                              groupAnswersStats
                                                                  .map((entry) =>
                                                                      entry[
                                                                          'question'])
                                                                  .toList();
                                                          List<String>
                                                              questionList =
                                                              questions2
                                                                  .map((dynamic
                                                                          value) =>
                                                                      value
                                                                          .toString())
                                                                  .toList();

                                                          List<String>
                                                              challengeQuestions =
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
                                                                    builder:
                                                                        (context) =>
                                                                            groupChallenge(
                                                                      groupName:
                                                                          widget
                                                                              .friendUsername,
                                                                      groupId:
                                                                          groupId,
                                                                      challengeQs:
                                                                          challengeQuestions,
                                                                      challengeId:
                                                                          id,
                                                                      completed:
                                                                          false,
                                                                      fromFriend:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                );
                                                              } else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            groupChallenge(
                                                                      groupName:
                                                                          widget
                                                                              .friendUsername,
                                                                      groupId:
                                                                          groupId,
                                                                      challengeQs:
                                                                          questionList,
                                                                      challengeId:
                                                                          id,
                                                                      completed:
                                                                          true,
                                                                      groupAnswers:
                                                                          groupAnswersStats,
                                                                      verbaMatchSimilarity:
                                                                          verbaMatchStats,
                                                                      totalResponses:
                                                                          totalResponsesStats,
                                                                      fromFriend:
                                                                          true,
                                                                      verbaMatchUsers:
                                                                          verbaMatchUsersStats,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 10,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    231,
                                                                    111,
                                                                    81),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    title,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color: Colors
                                                                        .white,
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
                                                            widget
                                                                .friendUsername);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            'New Challenge',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          const Icon(
                                                            Icons.add,
                                                            size: 20,
                                                            color: Colors.black,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),

                                      // Content for Stats
                                      Container(
                                          child: StatsContent(
                                        verbaMatchGroup: verbaMatchGroup,
                                        groupRating: groupRating,
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const Center(child: SizedBox(height: 50))
                    ]))
              ]))),
      drawer: const SideBar(),
    ));
  }
}

class StatsContent extends StatelessWidget {
  List<String> verbaMatchGroup;
  double groupRating;

  StatsContent({
    super.key,
    required this.verbaMatchGroup,
    required this.groupRating,
  });

  @override
  Widget build(BuildContext context) {
    String verba1 = verbaMatchGroup[0];
    String verba2 = verbaMatchGroup[1];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // color: Colors.white,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DonutChart(
                  groupSimilarity: groupRating, title: 'Group Power Score'),
            ),
          ),
          SizedBox(height: 15.v),
          /*
          Visibility(
            visible: verbaMatchGroup.length != 0,
            child: Container(
              child: Center(
                child: Text(
                  'Most Similar: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'
                  ),
                ),
              ),
            ),
          ),
          Visibility(
              visible: verbaMatchGroup.length == 0,
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
                            fontFamily: 'Poppins'
                          ),
                        ),
                        TextSpan(
                          text: 'Verba-',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'
                          ),
                        ),
                        TextSpan(
                          text: 'Matches...',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Visibility(
            visible: verbaMatchGroup.length == 0,
            child: SizedBox(
              height: 20,
            ),
          ),
          Visibility(
            visible: verbaMatchGroup.length == 0,
            child: Container(
              child: Center(
                child: Text(
                  'Play more challenges to match!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: verbaMatchGroup.length != 0,
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
                        fontFamily: 'Poppins'
                      ),
                    ),
                    TextSpan(
                      text: 'Match!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: verbaMatchGroup.length != 0,
            child: Container(
              child: Center(
                child: Text(
                  'hardcoded% Similarity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: verbaMatchGroup.length != 0,
            child: SizedBox(height: 10.v),
          ),
          Visibility(
            visible: verbaMatchGroup.length != 0,
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
            visible: verbaMatchGroup.length != 0,
            child: SizedBox(height: 15.v),
          ),
          Visibility(
            visible: verbaMatchGroup.length != 0,
            child: Container(
              child: Center(
                child: Text(
                  '$verba1 and $verba2',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'
                  ),
                ),
              ),
            ),
          ),*/
          SizedBox(height: 50.v)
        ],
      ),
    );
  }
}

class DonutChart extends StatefulWidget {
  final double groupSimilarity;
  final String title;

  const DonutChart({
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
              height: 200,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9E503C).withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(2, 3),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Your score increases when you:\n',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // if groupname is a certain length, make it a new line
                          TextSpan(
                            text:
                                'Verbatim, Build Streaks, and Play Challenges!',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.orange,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
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
      int score = similarity ~/ 2;

      return Color.fromARGB(255, 250, 192 + score, 94 + score);
    }

    double sim = widget.groupSimilarity;

    double outof100 = (widget.groupSimilarity / 100);
    if (outof100 < 1) {
      outof100 = 1;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _showPopup(context),
              child: const Icon(
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
                        value: outof100,
                        color: const Color(0xFFE76F51),
                        radius: 25,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 100 - outof100,
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
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 255, 243, 238),
                                blurRadius: 10.0,
                                spreadRadius: 10.0,
                                offset: Offset(3, 3)),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.groupSimilarity.toStringAsFixed(2),
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "Rating",
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
