import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatim_frontend/widgets/size.dart';

class Friend {
  final String name;
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4; // + 2
  final String answer5;

  Friend({
    required this.name,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4, // +2
    required this.answer5,
  });
}

class Stats extends StatelessWidget {
  final List<String> tabLabels;
  final Map<String, dynamic> statsQ1;
  final Map<String, dynamic> statsQ2;
  final Map<String, dynamic> statsQ3;
  final Map<String, dynamic> statsQ4; // +2
  final Map<String, dynamic> statsQ5;
  final int totalResponses;
  final List<String> questions;
  final List<String> responses;

  const Stats({
    super.key,
    required this.tabLabels,
    required this.totalResponses,
    required this.statsQ1,
    required this.statsQ2,
    required this.statsQ3,
    required this.statsQ4, //+2
    required this.statsQ5,
    required this.questions,
    required this.responses,
  });

  List<Friend> convertStatsToFriends(Map<String, dynamic> stats) {
    List<Friend> friends = [];
    for (final friendName in stats['statsQ1']['friendResponses'].keys) {
      final answer1 = stats['statsQ1']['friendResponses'][friendName];
      final answer2 = stats['statsQ2']['friendResponses'][friendName];
      final answer3 = stats['statsQ3']['friendResponses'][friendName];
      final answer4 = stats['statsQ4']['friendResponses'][friendName]; // +2
      final answer5 = stats['statsQ5']['friendResponses'][friendName];
      friends.add(Friend(
          name: friendName,
          answer1: answer1,
          answer2: answer2,
          answer3: answer3,
          answer4: answer4, // +2!
          answer5: answer5));
    }
    return friends;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> stats = {
      "statsQ1": statsQ1,
      "statsQ2": statsQ2,
      "statsQ3": statsQ3,
      "statsQ4": statsQ4, //+2!
      "statsQ5": statsQ5
    };
    List<Friend> friends = convertStatsToFriends(stats);

    // null case
    if (statsQ1["secondMostPopular"] == null) {
      statsQ1["secondMostPopular"] = ' ';
    }
    if (statsQ1["thirdMostPopular"] == null) {
      statsQ1["thirdMostPopular"] = ' ';
    }

    if (statsQ2["secondMostPopular"] == null) {
      statsQ2["secondMostPopular"] = ' ';
    }

    if (statsQ2["thirdMostPopular"] == null) {
      statsQ2["thirdMostPopular"] = ' ';
    }
    if (statsQ3["secondMostPopular"] == null) {
      statsQ3["secondMostPopular"] = ' ';
    }

    if (statsQ3["thirdMostPopular"] == null) {
      statsQ3["thirdMostPopular"] = ' ';
    }
    // +2!
    if (statsQ4["secondMostPopular"] == null) {
      statsQ4["secondMostPopular"] = ' ';
    }

    if (statsQ4["thirdMostPopular"] == null) {
      statsQ4["thirdMostPopular"] = ' ';
    }
    if (statsQ5["secondMostPopular"] == null) {
      statsQ5["secondMostPopular"] = ' ';
    }

    if (statsQ5["thirdMostPopular"] == null) {
      statsQ5["thirdMostPopular"] = ' ';
    }

    // calculations for pie chart
    double numTopResponses1 = statsQ1["numResponsesFirst"] +
        statsQ1["numResponsesSecond"] +
        statsQ1["numResponsesThird"];

    double numOther1 = totalResponses - numTopResponses1;

    double numTopResponses2 = statsQ2["numResponsesFirst"] +
        statsQ2["numResponsesSecond"] +
        statsQ2["numResponsesThird"];

    double numOther2 = totalResponses - numTopResponses2;

    double numTopResponses3 = statsQ3["numResponsesFirst"] +
        statsQ3["numResponsesSecond"] +
        statsQ3["numResponsesThird"];

    double numOther3 = totalResponses - numTopResponses3;

    //+2!
    double numTopResponses4 = statsQ4["numResponsesFirst"] +
        statsQ4["numResponsesSecond"] +
        statsQ4["numResponsesThird"];

    double numOther4 = totalResponses - numTopResponses3;

    double numTopResponses5 = statsQ5["numResponsesFirst"] +
        statsQ5["numResponsesSecond"] +
        statsQ5["numResponsesThird"];

    double numOther5 = totalResponses - numTopResponses3;

    const MaterialColor paleColor = MaterialColor(
      0xFFF3EE,
      <int, Color>{
        50: Color(0xFFFAFAFA),
        100: Color(0xFFF5F5F5),
        200: Color(0xFFEEEEEE),
        300: Color(0xFFE0E0E0),
        350: Color(0xFFD6D6D6),
        400: Color(0xFFBDBDBD),
        500: Color(0xFF9E9E9E),
        600: Color(0xFF757575),
        700: Color(0xFF616161),
        800: Color(0xFF424242),
        850: Color(0xFF303030),
        900: Color(0xFF212121),
      },
    );

    String yourAnswer1 = responses[0];
    String yourAnswer2 = responses[1];
    String yourAnswer3 = responses[2];
    //+2!
    String yourAnswer4 = responses[3];
    String yourAnswer5 = responses[4];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        primarySwatch: paleColor,
      ),
      home: DefaultTabController(
        length: tabLabels.length,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.black,
                indicatorColor: const Color(0xFFE76F51),
                labelColor: const Color(0xFFE76F51),
                tabs: tabLabels
                    .map((label) => Tab(
                          child: Text(
                            label,
                          ),
                        ))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: tabLabels
                  .asMap()
                  .map((index, label) {
                    Widget tabContent = const Center();

                    if (index == 0) {
                      tabContent = SingleChildScrollView(
                          child: Container(
                        child: Column(children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Center(
                              child: Text(
                                questions[0],
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 0,
                                sections: [
                                  PieChartSectionData(
                                      value: statsQ1["numResponsesFirst"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ1["numResponsesSecond"],
                                      color: const Color.fromRGBO(
                                          77, 161, 100, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ1["numResponsesThird"],
                                      color: const Color.fromRGBO(
                                          99, 118, 221, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: numOther1,
                                      color: const Color.fromRGBO(
                                          250, 192, 94, 1.0),
                                      radius: 80,
                                      title: ''),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 300,
                              child: Center(
                                child: Legend(
                                  data: [
                                    LegendData(
                                      title: statsQ1["firstMostPopular"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                    ),
                                    LegendData(
                                        title: statsQ1["secondMostPopular"],
                                        color: const Color.fromRGBO(
                                            77, 161, 100, 1.0)),
                                    LegendData(
                                        title: statsQ1["thirdMostPopular"],
                                        color: const Color.fromRGBO(
                                            99, 118, 221, 1.0)),
                                    LegendData(
                                        title: 'Other',
                                        color: const Color.fromRGBO(
                                            250, 192, 94, 1.0)),
                                  ],
                                ),
                              )),
                          SizedBox(height: 15.v),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You Said: '$yourAnswer1'",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: 200,
                              child: Center(
                                child: Text(
                                  "Friends' Answers",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 300,
                            height: 250,
                            child: friends.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      "None of your friends have played today. Add friends to see their answers!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ))
                                : Column(
                                    children: friends.asMap().entries.map(
                                      (entry) {
                                        final friend = entry.value;
                                        final friendName = friend.name;
                                        final friendAnswer1 = friend.answer1;

                                        if (entry.key.isEven) {
                                          final nextIndex = entry.key + 1;
                                          final hasNextFriend =
                                              nextIndex < friends.length;

                                          final nextFriendName = hasNextFriend
                                              ? friends[nextIndex].name
                                              : '';
                                          final nextAnswer = hasNextFriend
                                              ? friends[nextIndex].answer1
                                              : '';

                                          return Center(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: ListTile(
                                                  title: Center(
                                                    child: Row(children: [
                                                      const Icon(
                                                          Icons.account_circle),
                                                      Flexible(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style: DefaultTextStyle
                                                                    .of(context)
                                                                .style,
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    '$friendName: ',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    friendAnswer1,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                )),
                                                if (hasNextFriend)
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Center(
                                                        child: Row(children: [
                                                          const Icon(Icons
                                                              .account_circle),
                                                          Flexible(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                style: DefaultTextStyle.of(
                                                                        context)
                                                                    .style,
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        '$nextFriendName: ',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        nextAnswer,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ).toList(),
                                  ),
                          ),
                        ]),
                      ));
                    } else if (index == 1) {
                      tabContent = SingleChildScrollView(
                          child: Container(
                        child: Column(children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              questions[1],
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 0,
                                sections: [
                                  PieChartSectionData(
                                      value: statsQ2["numResponsesFirst"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ2["numResponsesSecond"],
                                      color: const Color.fromRGBO(
                                          77, 161, 100, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ2["numResponsesThird"],
                                      color: const Color.fromRGBO(
                                          99, 118, 221, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: numOther2,
                                      color: const Color.fromRGBO(
                                          250, 192, 94, 1.0),
                                      radius: 80,
                                      title: ''),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 300,
                              child: Center(
                                child: Legend(
                                  data: [
                                    LegendData(
                                      title: statsQ2["firstMostPopular"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                    ),
                                    LegendData(
                                        title: statsQ2["secondMostPopular"],
                                        color: const Color.fromRGBO(
                                            77, 161, 100, 1.0)),
                                    LegendData(
                                        title: statsQ2["thirdMostPopular"],
                                        color: const Color.fromRGBO(
                                            99, 118, 221, 1.0)),
                                    LegendData(
                                        title: 'Other',
                                        color: const Color.fromRGBO(
                                            250, 192, 94, 1.0)),
                                  ],
                                ),
                              )),
                          SizedBox(height: 15.v),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You Said: '$yourAnswer2'",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: 200,
                              child: Center(
                                child: Text(
                                  "Friends' Answers",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 300,
                              height: 250,
                              child: friends.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        "None of your friends have played today. Add friends to see their answers!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ))
                                  : Column(
                                      children: friends.asMap().entries.map(
                                        (entry) {
                                          final friend = entry.value;
                                          final friendName = friend.name;
                                          final friendAnswer2 = friend.answer2;

                                          if (entry.key.isEven) {
                                            final nextIndex = entry.key + 1;
                                            final hasNextFriend =
                                                nextIndex < friends.length;

                                            final nextFriendName = hasNextFriend
                                                ? friends[nextIndex].name
                                                : '';
                                            final nextAnswer = hasNextFriend
                                                ? friends[nextIndex].answer2
                                                : '';

                                            return Center(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: ListTile(
                                                    title: Center(
                                                      child: Row(children: [
                                                        const Icon(Icons
                                                            .account_circle),
                                                        Flexible(
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '$friendName: ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      friendAnswer2,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                  )),
                                                  if (hasNextFriend)
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Center(
                                                          child: Row(children: [
                                                            const Icon(Icons
                                                                .account_circle),
                                                            Flexible(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  style: DefaultTextStyle.of(
                                                                          context)
                                                                      .style,
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          '$nextFriendName: ',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          nextAnswer,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ).toList(),
                                    )),
                        ]),
                      ));
                    } else if (index == 2) {
                      tabContent = SingleChildScrollView(
                          child: Container(
                        child: Column(children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              questions[2],
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 300.v,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 0,
                                sections: [
                                  PieChartSectionData(
                                      value: statsQ3["numResponsesFirst"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ3["numResponsesSecond"],
                                      color: const Color.fromRGBO(
                                          77, 161, 100, 1.0),
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ3["numResponsesThird"],
                                      color: const Color.fromRGBO(
                                          99, 118, 221, 1.0),
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: numOther3,
                                      color: const Color.fromRGBO(
                                          250, 192, 94, 1.0),
                                      radius: 90,
                                      title: ''),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 300,
                              child: Center(
                                child: Legend(
                                  data: [
                                    LegendData(
                                      title: statsQ3["firstMostPopular"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                    ),
                                    LegendData(
                                        title: statsQ3["secondMostPopular"],
                                        color: const Color.fromRGBO(
                                            77, 161, 100, 1.0)),
                                    LegendData(
                                        title: statsQ3["thirdMostPopular"],
                                        color: const Color.fromRGBO(
                                            99, 118, 221, 1.0)),
                                    LegendData(
                                        title: 'Other',
                                        color: const Color.fromRGBO(
                                            250, 192, 94, 1.0)),
                                  ],
                                ),
                              )),
                          SizedBox(height: 15.v),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You Said: '$yourAnswer3'",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: 200,
                              child: Center(
                                child: Text(
                                  "Friends' Answers",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 300,
                            height: 250,
                            child: friends.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                        "None of your friends have played today. Add friends to see their answers!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        )))
                                : Column(
                                    children: friends.asMap().entries.map(
                                      (entry) {
                                        final friend = entry.value;
                                        final friendName = friend.name;
                                        final friendAnswer3 = friend.answer3;

                                        if (entry.key.isEven) {
                                          final nextIndex = entry.key + 1;
                                          final hasNextFriend =
                                              nextIndex < friends.length;

                                          final nextFriendName = hasNextFriend
                                              ? friends[nextIndex].name
                                              : '';
                                          final nextAnswer = hasNextFriend
                                              ? friends[nextIndex].answer3
                                              : '';

                                          return Center(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ListTile(
                                                    title: Center(
                                                      child: Row(children: [
                                                        const Icon(Icons
                                                            .account_circle),
                                                        Flexible(
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '$friendName: ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      friendAnswer3,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                                if (hasNextFriend)
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Center(
                                                        child: Row(children: [
                                                          const Icon(Icons
                                                              .account_circle),
                                                          Flexible(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                style: DefaultTextStyle.of(
                                                                        context)
                                                                    .style,
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        '$nextFriendName: ',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        nextAnswer,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ).toList(),
                                  ),
                          ),
                        ]),
                      ));
                      //+2!
                    } else if (index == 3) {
                      tabContent = SingleChildScrollView(
                          child: Container(
                        child: Column(children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              questions[3],
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 0,
                                sections: [
                                  PieChartSectionData(
                                      value: statsQ4["numResponsesFirst"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ4["numResponsesSecond"],
                                      color: const Color.fromRGBO(
                                          77, 161, 100, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ4["numResponsesThird"],
                                      color: const Color.fromRGBO(
                                          99, 118, 221, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: numOther4,
                                      color: const Color.fromRGBO(
                                          250, 192, 94, 1.0),
                                      radius: 80,
                                      title: ''),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 300,
                              child: Center(
                                child: Legend(
                                  data: [
                                    LegendData(
                                      title: statsQ4["firstMostPopular"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                    ),
                                    LegendData(
                                        title: statsQ4["secondMostPopular"],
                                        color: const Color.fromRGBO(
                                            77, 161, 100, 1.0)),
                                    LegendData(
                                        title: statsQ4["thirdMostPopular"],
                                        color: const Color.fromRGBO(
                                            99, 118, 221, 1.0)),
                                    LegendData(
                                        title: 'Other',
                                        color: const Color.fromRGBO(
                                            250, 192, 94, 1.0)),
                                  ],
                                ),
                              )),
                          SizedBox(height: 15.v),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You Said: '$yourAnswer4'",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: 200,
                              child: Center(
                                child: Text(
                                  "Friends' Answers",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 300,
                              height: 250,
                              child: friends.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        "None of your friends have played today. Add friends to see their answers!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ))
                                  : Column(
                                      children: friends.asMap().entries.map(
                                        (entry) {
                                          final friend = entry.value;
                                          final friendName = friend.name;
                                          final friendAnswer4 = friend.answer4;

                                          if (entry.key.isEven) {
                                            final nextIndex = entry.key + 1;
                                            final hasNextFriend =
                                                nextIndex < friends.length;

                                            final nextFriendName = hasNextFriend
                                                ? friends[nextIndex].name
                                                : '';
                                            final nextAnswer = hasNextFriend
                                                ? friends[nextIndex].answer4
                                                : '';

                                            return Center(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: ListTile(
                                                    title: Center(
                                                      child: Row(children: [
                                                        const Icon(Icons
                                                            .account_circle),
                                                        Flexible(
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '$friendName: ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      friendAnswer4,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                  )),
                                                  if (hasNextFriend)
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Center(
                                                          child: Row(children: [
                                                            const Icon(Icons
                                                                .account_circle),
                                                            Flexible(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  style: DefaultTextStyle.of(
                                                                          context)
                                                                      .style,
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          '$nextFriendName: ',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          nextAnswer,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ).toList(),
                                    )),
                        ]),
                      ));
                    } else if (index == 4) {
                      tabContent = SingleChildScrollView(
                          child: Container(
                        child: Column(children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              questions[4],
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 0,
                                sections: [
                                  PieChartSectionData(
                                      value: statsQ5["numResponsesFirst"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ5["numResponsesSecond"],
                                      color: const Color.fromRGBO(
                                          77, 161, 100, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ5["numResponsesThird"],
                                      color: const Color.fromRGBO(
                                          99, 118, 221, 1.0),
                                      radius: 80,
                                      title: ''),
                                  PieChartSectionData(
                                      value: numOther5,
                                      color: const Color.fromRGBO(
                                          250, 192, 94, 1.0),
                                      radius: 80,
                                      title: ''),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 300,
                              child: Center(
                                child: Legend(
                                  data: [
                                    LegendData(
                                      title: statsQ5["firstMostPopular"],
                                      color: const Color.fromRGBO(
                                          231, 111, 81, 1.0),
                                    ),
                                    LegendData(
                                        title: statsQ5["secondMostPopular"],
                                        color: const Color.fromRGBO(
                                            77, 161, 100, 1.0)),
                                    LegendData(
                                        title: statsQ5["thirdMostPopular"],
                                        color: const Color.fromRGBO(
                                            99, 118, 221, 1.0)),
                                    LegendData(
                                        title: 'Other',
                                        color: const Color.fromRGBO(
                                            250, 192, 94, 1.0)),
                                  ],
                                ),
                              )),
                          SizedBox(height: 15.v),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You Said: '$yourAnswer5'",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: 200,
                              child: Center(
                                child: Text(
                                  "Friends' Answers",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 300,
                              height: 250,
                              child: friends.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                          "None of your friends have played today. Add friends to see their answers!",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                            ),
                                          )))
                                  : Column(
                                      children: friends.asMap().entries.map(
                                        (entry) {
                                          final friend = entry.value;
                                          final friendName = friend.name;
                                          final friendAnswer5 = friend.answer5;

                                          if (entry.key.isEven) {
                                            final nextIndex = entry.key + 1;
                                            final hasNextFriend =
                                                nextIndex < friends.length;

                                            final nextFriendName = hasNextFriend
                                                ? friends[nextIndex].name
                                                : '';
                                            final nextAnswer = hasNextFriend
                                                ? friends[nextIndex].answer5
                                                : '';

                                            return Center(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: ListTile(
                                                    title: Center(
                                                      child: Row(children: [
                                                        const Icon(Icons
                                                            .account_circle),
                                                        Flexible(
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '$friendName: ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      friendAnswer5,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                  )),
                                                  if (hasNextFriend)
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Center(
                                                          child: Row(children: [
                                                            const Icon(Icons
                                                                .account_circle),
                                                            Flexible(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  style: DefaultTextStyle.of(
                                                                          context)
                                                                      .style,
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          '$nextFriendName: ',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          nextAnswer,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ]),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ).toList(),
                                    )),
                        ]),
                      ));
                    }

                    return MapEntry(index, tabContent);
                  })
                  .values
                  .toList(),
            )),
      ),
    );
  }
}

class LegendData {
  final String title;
  final Color color;

  LegendData({required this.title, required this.color});
}

class Legend extends StatelessWidget {
  final List<LegendData> data;

  const Legend({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const itemsPerRow = 1;

    final rows = <Widget>[];
    for (int i = 0; i < data.length; i += itemsPerRow) {
      final rowItems = data.sublist(i, i + itemsPerRow);
      final row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowItems.map((item) {
          return Flexible(
              flex: 0,
              child: Center(
                  child: Row(
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    color: item.color,
                  ),
                  const SizedBox(width: 5),
                  Text(item.title),
                  const SizedBox(width: 5),
                ],
              )));
        }).toList(),
      );
      rows.add(row);
      rows.add(const SizedBox(height: 5));
    }

    return Center(child: Column(children: rows));
  }
}
