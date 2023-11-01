import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

// need to get this from backend
  final List<Friend> friends = [
    Friend(
        name: 'Amy Park',
        answer1: 'Tennis',
        answer2: 'Answer 2',
        answer3: 'Answer 3'),
    Friend(
        name: 'friend withalonglastname',
        answer1: 'Answer 1',
        answer2: 'Answer 2',
        answer3: 'Answer 3'),
    Friend(
        name: 'Friend 3',
        answer1: 'Answer 1',
        answer2: 'Answer 2',
        answer3: 'Answer 3'),
    Friend(
        name: 'Friend 4',
        answer1: 'Answer 1',
        answer2: 'Answer 2',
        answer3: 'Answer 3'),
    Friend(
        name: 'Friend 5',
        answer1: 'Answer 1',
        answer2: 'Answer 2',
        answer3: 'Answer 3'),
    Friend(
        name: 'Friend 6',
        answer1: 'Answer 1',
        answer2: 'Answer 2',
        answer3: 'Answer 3'),
    Friend(
        name: 'Friend 7',
        answer1: 'Answer 1',
        answer2: 'Answer 2',
        answer3: 'Answer 3'),
    Friend(
        name: 'Friend 8',
        answer1: 'Answer 1',
        answer2: 'Answer 2',
        answer3: 'Answer 3'),
  ];

  @override
  Widget build(BuildContext context) {
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
                            height: 250,
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
                              width: 200,
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
                            width: 250,
                            height: 250,
                            child: Center(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: friends.length,
                                itemBuilder: (context, index) {
                                  final friend = friends[index];
                                  final friendName = friend.name;
                                  final friendAnswer1 = friend.answer1;

                                  if (index.isEven) {
                                    final nextIndex = index + 1;
                                    final nextFriendName =
                                        friends[nextIndex].name;
                                    final nextAnswer =
                                        friends[index + 1].answer1;

                                    return Center(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: '$friendName: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: friendAnswer1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '$nextFriendName: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: nextAnswer,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return SizedBox(); // return an empty widget for odd index to maintain even-odd pairs
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
                              width: 250,
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
                            width: 250,
                            height: 250,
                            child: Center(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: friends.length,
                                itemBuilder: (context, index) {
                                  final friend = friends[index];
                                  final friendName = friend.name;
                                  final friendAnswer1 = friend.answer1;

                                  if (index.isEven) {
                                    final nextIndex = index + 1;
                                    final nextFriendName =
                                        friends[nextIndex].name;
                                    final nextAnswer =
                                        friends[index + 1].answer1;

                                    return Center(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: '$friendName: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: friendAnswer1,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '$nextFriendName: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: nextAnswer,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return SizedBox(); // return an empty widget for odd index to maintain even-odd pairs
                                  }
                                },
                              ),
                            ),
                          ),
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
                              width: 200,
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
                            width: 250,
                            height: 250,
                            child: Center(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: friends.length,
                                itemBuilder: (context, index) {
                                  final friend = friends[index];
                                  final friendName = friend.name;
                                  final friendAnswer3 = friend.answer3;

                                  if (index.isEven) {
                                    final nextIndex = index + 1;
                                    final nextFriendName =
                                        friends[nextIndex].name;
                                    final nextAnswer =
                                        friends[index + 1].answer3;

                                    return Center(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: '$friendName: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: friendAnswer3,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '$nextFriendName: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: nextAnswer,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return SizedBox(); // return an empty widget for odd index to maintain even-odd pairs
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
