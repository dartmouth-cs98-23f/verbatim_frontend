import 'package:flutter/material.dart';
import 'sideBar.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class globalChallenge extends StatefulWidget {
  final String email;
  final String password;

  globalChallenge({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _GlobalChallengeState createState() => _GlobalChallengeState();

}

class _GlobalChallengeState extends State<globalChallenge> {
  String userResponse = '';
  TextEditingController responseController = TextEditingController();

  // Test method to print the passed-in user info from log-in page
  void printUserInfo() {
    print('Email in gb: ${widget.email}, Password in gb: ${widget.password}');
  }

  bool response = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
                            child: response

                                // if a response has been submitted;
                                ? Column(
                                    children: [
                                      SizedBox(height: 30.0),
                                      Text(
                                        'Sports that start with "T"',
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
                                              text: userResponse,
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
                                        'Sports that start with "T"',
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
                                              responseController.clear();
                                              response = true;
                                            });
                                            printUserInfo();
                                          },
                                          child: Text('Submit!'),
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
                                          'Sports that start with "T"',
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
