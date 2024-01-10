import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/create_group_app_bar.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class nameGroup extends StatefulWidget {
  final List<String> addedUsernames;

  nameGroup(this.addedUsernames);

  @override
  _NameGroupState createState() => _NameGroupState();
}

class _NameGroupState extends State<nameGroup> {
  String username = SharedPrefs().getUserName() ?? "";
  TextEditingController responseController = TextEditingController();
  String userResponse = '';

  Widget build(BuildContext context) {
    // get added usernames from parameter
    final List<String> addedUsernames = widget.addedUsernames;
    String addedUsernamesString = addedUsernames.join(', ');
    print(addedUsernames);
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
                          height: 240.v,
                          width: double.maxFinite,
                          child:
                              Stack(alignment: Alignment.topCenter, children: [
                            // orange background
                            Container(
                              height: 220.v,
                              width: double.maxFinite,
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              child: SvgPicture.asset(
                                assetName,
                                fit: BoxFit.fill,
                              ),
                            ),
                            createGroupAppBar(), // appbar on top of orange background
                          ])),
                      Center(
                          child: Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.only(top: 10),
                              width: 300.h,
                              height: 430.v,
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
                              child: Column(children: [
                                SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    'Word! Give your group a name!',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: TextField(
                                    controller: responseController,
                                    onChanged: (value) {
                                      setState(() {
                                        userResponse = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Type your group name here...',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Text(
                                  'Added Usernames: $addedUsernamesString',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ]))),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              handleTap(context, 0);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: const Size(100, 50),
                              side: BorderSide(color: Color(0xFFE76F51)),
                            ),
                            child: Text(
                              'Cancel ',
                              style: TextStyle(
                                color: Color(0xFFE76F51),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              handleTap(context, 1);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFE76F51),
                              padding: EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: const Size(100, 50),
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ]))
              ]))),
      drawer: SideBar(),
    ));
  }
}

void handleTap(BuildContext context, int index) {
  switch (index) {
    case 0: // "Global Challenge"
      // ignore: prefer_typing_uninitialized_variables
      Navigator.pushNamed(context,
          '/create_group'); //fix it so it automatically has ur settings from create group stage
      break;
    case 1: // "Group Name"
      Navigator.pushNamed(context, '/name_group');
      break;
  }
}
