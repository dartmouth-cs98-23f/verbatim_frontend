import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/widgets/size.dart';

class Friend {
  final String name;
  final String answer1;
  final String answer2;
  final String answer3;

  Friend({
    required this.name,
    required this.answer1,
    required this.answer2,
    required this.answer3,
  });
}

class Stats extends StatelessWidget {
  final List<String> tabLabels;
  final Map<String, dynamic> statsQ1;
  final Map<String, dynamic> statsQ2;
  final Map<String, dynamic> statsQ3;
  final int totalResponses;

  Stats({
    required this.tabLabels,
    required this.totalResponses,
    required this.statsQ1,
    required this.statsQ2,
    required this.statsQ3,
  });

  List<Friend> convertStatsToFriends(Map<String, dynamic> stats) {
    List<Friend> friends = [];
    for (final friendName in stats['statsQ1']['friendResponses'].keys) {
      final answer1 = stats['statsQ1']['friendResponses'][friendName];
      final answer2 = stats['statsQ2']['friendResponses'][friendName];
      final answer3 = stats['statsQ3']['friendResponses'][friendName];
      friends.add(Friend(
          name: friendName,
          answer1: answer1,
          answer2: answer2,
          answer3: answer3));
    }
    return friends;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> stats = {
      "statsQ1": statsQ1,
      "statsQ2": statsQ2,
      "statsQ3": statsQ3
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: DefaultTabController(
        length: tabLabels.length,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: TabBar(
                unselectedLabelColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
                indicatorColor: Colors.orange,
                labelColor: Colors.orange,
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: tabLabels.map((label) => Tab(text: label)).toList(),
              ),
            ),
            body: TabBarView(
              children: tabLabels
                  .asMap()
                  .map((index, label) {
                    Widget tabContent = Center(child: Text('Default Content'));

                    if (index == 0) {
                      tabContent = SingleChildScrollView(
                          child: Center(
                        child: Column(children: [
                          Container(
                            height: 400.v,
                            width: 500,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 0,
                                sections: [
                                  PieChartSectionData(
                                      value: statsQ1["numResponsesFirst"],
                                      color: Colors.red,
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ1["numResponsesSecond"],
                                      color: Colors.green,
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ1["numResponsesThird"],
                                      color: Colors.blue,
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: numOther1,
                                      color: Colors.yellow,
                                      radius: 90,
                                      title: ''),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              width: 300.h,
                              child: Center(
                                child: Legend(
                                  data: [
                                    LegendData(
                                        title: statsQ1["firstMostPopular"],
                                        color: Colors.red),
                                    LegendData(
                                        title: statsQ1["secondMostPopular"],
                                        color: Colors.green),
                                    LegendData(
                                        title: statsQ1["thirdMostPopular"],
                                        color: Colors.blue),
                                    LegendData(
                                        title: 'Other', color: Colors.yellow),
                                  ],
                                ),
                              )),
                          SizedBox(height: 20),
                          Container(
                              width: 200,
                              child: Center(
                                child: Text(
                                  "Friends' Answers",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                          SizedBox(height: 10),
                          Container(
                            width: 300.h,
                            height: 250,
                            child: friends.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      "None of your friends have played today. Add friends to see their answers!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ))
                                : Center(
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: friends.length,
                                      itemBuilder: (context, index) {
                                        final friend = friends[index];
                                        final friendName = friend.name;
                                        final friendAnswer1 = friend.answer1;

                                        if (index.isEven) {
                                          final nextIndex = index + 1;
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
                                                      Icon(
                                                          Icons.account_circle),
                                                      RichText(
                                                        text: TextSpan(
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  '$friendName: ',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  friendAnswer1,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ],
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
                                                          Icon(Icons
                                                              .account_circle),
                                                          RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '$nextFriendName: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      nextAnswer,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                  ),
                          ),
                        ]),
                      ));
                    } else if (index == 1) {
                      tabContent = SingleChildScrollView(
                          child: Center(
                        child: Column(children: [
                          Container(
                            height: 240,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 0,
                                sections: [
                                  PieChartSectionData(
                                      value: statsQ2["numResponsesFirst"],
                                      color: Colors.red,
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ2["numResponsesSecond"],
                                      color: Colors.green,
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ2["numResponsesThird"],
                                      color: Colors.blue,
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: numOther2,
                                      color: Colors.yellow,
                                      radius: 90,
                                      title: ''),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              width: 300.h,
                              child: Center(
                                child: Legend(
                                  data: [
                                    LegendData(
                                        title: statsQ2["firstMostPopular"],
                                        color: Colors.red),
                                    LegendData(
                                        title: statsQ2["secondMostPopular"],
                                        color: Colors.green),
                                    LegendData(
                                        title: statsQ2["thirdMostPopular"],
                                        color: Colors.blue),
                                    LegendData(
                                        title: 'Other', color: Colors.yellow),
                                  ],
                                ),
                              )),
                          SizedBox(height: 20),
                          Container(
                              width: 200,
                              child: Center(
                                child: Text(
                                  "Friends' Answers",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                          SizedBox(height: 10),
                          Container(
                              width: 300.h,
                              height: 250,
                              child: friends.isEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        "Add friends to see their answers!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ))
                                  : Center(
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: friends.length,
                                        itemBuilder: (context, index) {
                                          final friend = friends[index];
                                          final friendName = friend.name;
                                          final friendAnswer1 = friend.answer1;

                                          if (index.isEven) {
                                            final nextIndex = index + 1;
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
                                                        Icon(Icons
                                                            .account_circle),
                                                        RichText(
                                                          text: TextSpan(
                                                            style: DefaultTextStyle
                                                                    .of(context)
                                                                .style,
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    '$friendName: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    friendAnswer1,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
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
                                                            Icon(Icons
                                                                .account_circle),
                                                            RichText(
                                                              text: TextSpan(
                                                                style: DefaultTextStyle.of(
                                                                        context)
                                                                    .style,
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        '$nextFriendName: ',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        nextAnswer,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return SizedBox();
                                          }
                                        },
                                      ),
                                    )),
                        ]),
                      ));
                    } else if (index == 2) {
                      tabContent = SingleChildScrollView(
                          child: Center(
                        child: Column(children: [
                          Container(
                            height: 240,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 0,
                                sections: [
                                  PieChartSectionData(
                                      value: statsQ3["numResponsesFirst"],
                                      color: Colors.red,
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ3["numResponsesSecond"],
                                      color: Colors.green,
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: statsQ3["numResponsesThird"],
                                      color: Colors.blue,
                                      radius: 90,
                                      title: ''),
                                  PieChartSectionData(
                                      value: numOther3,
                                      color: Colors.yellow,
                                      radius: 90,
                                      title: ''),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              width: 300.h,
                              child: Center(
                                child: Legend(
                                  data: [
                                    LegendData(
                                        title: statsQ3["firstMostPopular"],
                                        color: Colors.red),
                                    LegendData(
                                        title: statsQ3["secondMostPopular"],
                                        color: Colors.green),
                                    LegendData(
                                        title: statsQ3["thirdMostPopular"],
                                        color: Colors.blue),
                                    LegendData(
                                        title: 'Other', color: Colors.yellow),
                                  ],
                                ),
                              )),
                          SizedBox(height: 20),
                          Container(
                              width: 200,
                              child: Center(
                                child: Text(
                                  "Friends' Answers",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                          SizedBox(height: 10),
                          Container(
                            width: 300.h,
                            height: 250,
                            child: friends.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      "Add friends to see their answers!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ))
                                : Center(
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: friends.length,
                                      itemBuilder: (context, index) {
                                        final friend = friends[index];
                                        final friendName = friend.name;
                                        final friendAnswer1 = friend.answer1;

                                        if (index.isEven) {
                                          final nextIndex = index + 1;
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
                                                        Icon(Icons
                                                            .account_circle),
                                                        RichText(
                                                          text: TextSpan(
                                                            style: DefaultTextStyle
                                                                    .of(context)
                                                                .style,
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    '$friendName: ',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    friendAnswer1,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                                if (hasNextFriend)
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Center(
                                                        child: Row(children: [
                                                          Icon(Icons
                                                              .account_circle),
                                                          RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '$nextFriendName: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      nextAnswer,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                  ),
                          ),
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

  Legend({required this.data});

  @override
  Widget build(BuildContext context) {
    final itemsPerRow = 2;

    final rows = <Widget>[];
    for (int i = 0; i < data.length; i += itemsPerRow) {
      final rowItems = data.sublist(i, i + itemsPerRow);
      final row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowItems.map((item) {
          return Center(
              child: Row(
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                color: item.color,
              ),
              SizedBox(width: 5),
              Text(item.title),
              SizedBox(width: 10),
            ],
          ));
        }).toList(),
      );
      rows.add(row);
      rows.add(SizedBox(height: 10));
    }

    return Center(child: Column(children: rows));
  }
}
