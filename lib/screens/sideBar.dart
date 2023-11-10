import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/Components/shared_prefs.dart';

class User {
  int id = 0;
  String email = "";
  String username = "";
  String lastName = "";
  String password = "";
  dynamic profilePicture;
  String? bio = "";
  int numGlobalChallengesCompleted = 0;
  int numCustomChallengesCompleted = 0;
  int streak = 0;
  bool hasCompletedDailyChallenge = false;

  User({required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
    );
  }
}

class FriendAcceptOrDeclineRequest {
  String requestingUsername;
  String requestedUsername;
  bool accept;

  FriendAcceptOrDeclineRequest({
    required this.requestingUsername,
    required this.requestedUsername,
    required this.accept,
  });

  Map<String, dynamic> toJson() {
    return {
      "requestingUsername": requestingUsername,
      "requestedUsername": requestedUsername,
      "accept": accept,
    };
  }
}

class SideBar extends StatefulWidget {
  SideBar({
    Key? key,
  }) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String username = SharedPrefs().getUserName() ?? "";

  final Color primary = Color.fromARGB(255, 231, 111, 81);

  Set<String> friendRequestUsernames = <String>{};
  List<String> usernamesList = [];

  Future<void> getFriends(String username) async {
    final url = Uri.parse('http://localhost:8080/api/v1/getFriends');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
      print('responses sent succesfully');
      final List<dynamic> data = json.decode(response.body);
      List<User> friendsList = data.map((item) => User.fromJson(item)).toList();
      usernamesList = friendsList.map((user) => user.username).toList();
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  Future<void> getFriendRequests(String username) async {
    final url = Uri.parse('http://localhost:8080/api/v1/getFriendRequests');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
      print('responses sent succesfully');

      List<Map<String, dynamic>> friendRequests =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      if (friendRequests.isNotEmpty) {
        print(friendRequests);

        for (var request in friendRequests) {
          String username = request['username'];
          friendRequestUsernames.add(username);
        }
      }
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  Future<void> handleFriendRequests(
      String username, String requester, bool accept) async {
    final url = Uri.parse('http://localhost:8080/api/v1/handleFriendRequest');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(FriendAcceptOrDeclineRequest(
        requestingUsername: requester,
        requestedUsername: username,
        accept: accept,
      )),
    );

    if (response.statusCode == 200) {
      print('responses sent succesfully');
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    username = SharedPrefs().getUserName() ?? "";
    return FutureBuilder<void>(
        future: Future.wait([
          getFriends(username),
          getFriendRequests(username),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Drawer(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
                    child: Container(
                        height: 64,
                        decoration: ShapeDecoration(
                          color: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Center(
                          child: ListTile(
                            title: Text(
                              username,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            leading:
                                Icon(Icons.mood, color: Colors.white, size: 32),
                            trailing: Icon(Icons.settings,
                                color: Colors.white, size: 26),
                            onTap: () {
                              handleTap(context, 2);
                            },
                          ),
                        )),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text('Global Challenge',
                            style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                        leading: Icon(Icons.home, color: primary),
                        onTap: () {
                          handleTap(context, 0);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ExpansionTile(
                    title: Text('Friends',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),

                    trailing: GestureDetector(
                      onTap: () {
                        handleTap(context, 1);
                      },
                      child: Icon(Icons.add, color: Colors.black, size: 25),
                    ),

                    initiallyExpanded: true,
                    shape:
                        Border(), // this will expand all of them - need to make a custom expansion tile at some point to fix this (i think)

                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: usernamesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            String friend = usernamesList[index];

                            return ListTile(
                              title: Text(
                                friend,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              leading: Icon(Icons.person, color: Colors.black),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ExpansionTile(
                    title: Text(
                      'Groups',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    trailing: Icon(Icons.add, color: Colors.black, size: 25),
                    //  initiallyExpanded: true,
                    shape: Border(),
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: .1),
                          child: ListTile(
                            title: Text('Group 1',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            leading: Icon(Icons.people, color: Colors.black),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ExpansionTile(
                    title: Text(
                      'Friend Requests',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    trailing: friendRequestUsernames.isNotEmpty
                        ? Icon(Icons.pending, color: Colors.orange, size: 25)
                        : Icon(Icons.pending, color: Colors.black, size: 25),
                    shape: Border(),
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: friendRequestUsernames.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<String> requestsList =
                                friendRequestUsernames.toList();
                            String requester = requestsList[index];

                            return ListTile(
                              title: Text(
                                requester,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              leading: Icon(Icons.person, color: Colors.black),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      handleFriendRequests(
                                          username, requester, true);
                                      setState(() {
                                        friendRequestUsernames
                                            .remove(requester);
                                      });
                                    },
                                    child: Icon(Icons.check_box,
                                        color: Colors.black),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      handleFriendRequests(
                                          username, requester, false);
                                      setState(() {
                                        friendRequestUsernames
                                            .remove(requester);
                                      });
                                    },
                                    child:
                                        Icon(Icons.cancel, color: Colors.black),
                                  ),
                                ],
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ListTile(
                    title: Text('More',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    onTap: () {},
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
                      child: ListTile(
                        title: Text('Custom Challenge',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        leading: Icon(Icons.play_arrow, color: Colors.black),
                        onTap: () {},
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
                      child: ListTile(
                        title: Text('Invite Friends',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        leading: Icon(Icons.person_add, color: Colors.black),
                        onTap: () {},
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
                      child: ListTile(
                        title: Text('Logout',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        leading: Icon(Icons.logout, color: Colors.black),
                        onTap: () {
                          Navigator.pushNamed(context, '/logout');
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }
        });
  }
}

void handleTap(BuildContext context, int index) {
  switch (index) {
    case 0: // "Global Challenge"
      // ignore: prefer_typing_uninitialized_variables
      Navigator.pushNamed(context, '/global_challenge');
      break;
    case 1: // "Group Name"
      Navigator.pushNamed(context, '/add_friend');
      break;
    case 2: // "Settings"
      Navigator.pushNamed(context, '/settings');
      break;

    case 3: // "Logout"
      Navigator.pushNamed(context, '/logout');
      break;
  }
}
