import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verbatim_frontend/BackendService.dart';
import 'dart:convert';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';

// class User {
//   int id = 0;
//   String email = "";
//   String username = "";
//   String lastName = "";
//   String password = "";
//   dynamic profilePicture;
//   String? bio = "";
//   int numGlobalChallengesCompleted = 0;
//   int numCustomChallengesCompleted = 0;
//   int streak = 0;
//   bool hasCompletedDailyChallenge = false;

//   User({required this.username});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       username: json['username'],
//     );
//   }
// }

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
  const SideBar({
    Key? key,
  }) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String username = SharedPrefs().getUserName() ?? "";

  final Color primary = const Color.fromARGB(255, 231, 111, 81);

  Set<String> friendRequestUsernames = <String>{};
  List<String> usernamesList = [];

  Future<void> getFriends(String username) async {
    final url = Uri.parse('${BackendService.getBackendUrl()}getFriends');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<User> friendsList = data.map((item) => User.fromJson(item)).toList();
      usernamesList = friendsList.map((user) => user.username).toList();
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  Future<void> getFriendRequests(String username) async {
    final url = Uri.parse('${BackendService.getBackendUrl()}getFriendRequests');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
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
    final url =
        Uri.parse('${BackendService.getBackendUrl()}handleFriendRequest');
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
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Drawer(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
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
                                  const TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            leading:
                                const Icon(Icons.mood, color: Colors.white, size: 32),
                            trailing: const Icon(Icons.settings,
                                color: Colors.white, size: 26),
                            onTap: () {
                              handleTap(context, 2);
                            },
                          ),
                        )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
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
                  const SizedBox(height: 20.0),
                  ExpansionTile(
                    title: const Text('Friends',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),

                    // takes you to the addFriend page
                    trailing: GestureDetector(
                      onTap: () {
                        handleTap(context, 1);
                      },
                      child: const Icon(Icons.add, color: Colors.black, size: 25),
                    ),

                    initiallyExpanded: true,
                    shape:
                        const Border(), // this will expand all of them - need to make a custom expansion tile at some point to fix this (i think)

                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: usernamesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            String friend = usernamesList[index];

                            return ListTile(
                              title: Text(
                                friend,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              leading: const Icon(Icons.person, color: Colors.black),
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ExpansionTile(
                    title: const Text(
                      'Groups',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),

                    // takes you to the add groups page
                    trailing: GestureDetector(
                      onTap: () {
                        handleTap(context, 4);
                      },
                      child: const Icon(Icons.add, color: Colors.black, size: 25),
                    ),
                    initiallyExpanded: true,
                    //  initiallyExpanded: true,
                    shape: const Border(),
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: .1),
                          child: ListTile(
                            title: const Text('Group 1',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            leading: const Icon(Icons.people, color: Colors.black),
                            onTap: () {
                              handleTap(context, 5);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ExpansionTile(
                    title: const Text(
                      'Friend Requests',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    trailing: friendRequestUsernames.isNotEmpty
                        ? const Icon(Icons.pending, color: Colors.orange, size: 25)
                        : const Icon(Icons.pending, color: Colors.black, size: 25),
                    shape: const Border(),
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: friendRequestUsernames.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<String> requestsList =
                                friendRequestUsernames.toList();
                            String requester = requestsList[index];

                            return ListTile(
                              title: Text(
                                requester,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              leading: const Icon(Icons.person, color: Colors.black),
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
                                    child: const Icon(Icons.check_box,
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
                                        const Icon(Icons.cancel, color: Colors.black),
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
                  const SizedBox(height: 20.0),
                  ListTile(
                    title: const Text('More',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    onTap: () {},
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
                      child: ListTile(
                        title: const Text('Custom Challenge',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        leading: const Icon(Icons.play_arrow, color: Colors.black),
                        onTap: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
                      child: ListTile(
                        title: const Text('Invite Friends',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        leading: const Icon(Icons.person_add, color: Colors.black),
                        onTap: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
                      child: ListTile(
                        title: const Text('Logout',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        leading: const Icon(Icons.logout, color: Colors.black),
                        onTap: () {
                          Navigator.pushNamed(context, '/logout');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
      Navigator.pushNamed(context, '/profile');
      break;
    // case 3: // "Profile"
    //   Navigator.pushNamed(context, '/profile');
    //   break;

    case 3: // "Logout"
      Navigator.pushNamed(context, '/logout');
      break;

    case 4: // "Create Group"
      Navigator.pushNamed(context, '/create_group');
      break;

    case 5: // "My Group"
      String userResponse = 'kool kids';
      List<String> addedUsernames = ['frances'];
      Navigator.pushNamed(
        context,
        '/my_group/${Uri.encodeComponent(userResponse)}/${Uri.encodeComponent(addedUsernames.join(','))}',
      );
      break;
  }
}
