import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sideBar.dart';
import 'package:verbatim_frontend/main.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class globalChallenge extends StatefulWidget {
  @override
  _GlobalChallengeState createState() => _GlobalChallengeState();
}

class _GlobalChallengeState extends State<globalChallenge> {
  String userResponse = ''; // Variable to store the user's response
  TextEditingController responseController = TextEditingController();

  bool response = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verbatim',
          style: TextStyle(
            fontSize: 18, // Adjust the font size
            fontWeight: FontWeight.bold, // Apply bold style
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_alert), // Replace with your desired icon
            onPressed: () {
              // Handle the button press
            },
          ),
        ],
        centerTitle: false, // Align title to the left
      ),
      drawer: SideBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              'Global Challenge #17',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: (500 * (screenHeight / 650)),
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: DefaultTabController(
                length: 2, // Number of tabs
                child: Column(
                  children: [
                    Expanded(
                      child: TabBar(
                        indicatorColor: Colors
                            .black, // Set the indicator (selected tab) color to black
                        labelColor: Colors.black,
                        tabs: [
                          Tab(text: 'Play'),
                          Tab(text: 'Global Stats'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex:
                          7, // Adjust the flex value to control the tab content size
                      child: TabBarView(
                        children: [
                          Center(
                            child: response
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
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'You said: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors
                                                    .black, // Change the color to your preference
                                              ),
                                            ),
                                            TextSpan(
                                              text: userResponse,
                                              style: TextStyle(
                                                fontSize: 24, // Make it big
                                                fontWeight: FontWeight
                                                    .bold, // Make it bold
                                                color: Colors
                                                    .black, // Change the color to your preference
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Visibility(
                                        visible:
                                            !response, // Show the button when response is false
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                              255,
                                              22,
                                              93,
                                              151,
                                            ), // Background color
                                            foregroundColor:
                                                Colors.white, // Text color
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
                                          },
                                          child: Text('Submit!'),
                                        ),
                                      ),
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
                                        visible:
                                            !response, // Show the button when response is false
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                              255,
                                              22,
                                              93,
                                              151,
                                            ), // Background color
                                            foregroundColor:
                                                Colors.white, // Text color
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
                          Center(
                              child: response
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
                                                    // Add the text you want above the grid
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
                                                  maxCrossAxisExtent:
                                                      200.0, // Adjust the width of each column as needed
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
                                                    // Add the text you want above the grid
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
