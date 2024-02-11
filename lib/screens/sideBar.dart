import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/defineRoutes.dart';
import 'dart:convert';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/User.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/screens/profile.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';

class UserGroup {
  int id = 0;
  String groupName = "";

  UserGroup({required this.groupName, required this.id});

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(groupName: json['name'], id: json['id']);
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
  const SideBar({
    Key? key,
  }) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String username = SharedPrefs().getUserName() as String;

  final Color primary = const Color.fromARGB(255, 231, 111, 81);

  List<User> friendRequests = [];
  List<User> friends = [];
  List<String> groupnamesList = [];
  List<UserGroup> userGroups = [];

  //get groups
  Future<void> getMyGroups(String username) async {
    final url = Uri.parse(
        BackendService.getBackendUrl() + 'user/' + '$username/' + 'groups');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> groups = data['groups'];

      for (Map<String, dynamic> group in groups) {
        int id = group["id"];
        String name = group["name"];
        userGroups.add(UserGroup(id: id, groupName: name));
        groupnamesList.add(name);
      }
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

// getFriends - can I get the friend:user groupId here?
  Future<void> getFriends(String username) async {
    final url = Uri.parse('${BackendService.getBackendUrl()}getFriends');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      friends = data.map((item) => User.fromJson(item)).toList();
      friends.removeWhere((user) => user.username == username);
      friends.forEach((user) {
        user.isRequested = true;
      });
    } else {
      print('Failed to get friends. Status code: ${response.statusCode}');
    }
  }

  Future<void> getFriendRequests(String username) async {
    final url = Uri.parse('${BackendService.getBackendUrl()}getFriendRequests');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      friendRequests = data.map((item) => User.fromJson(item)).toList();
      friendRequests.removeWhere((user) => user.username == username);
    } else {
      print(
          'Failed to get friend requests. Status code: ${response.statusCode}');
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
    BuildContext context1 = context;

    username = SharedPrefs().getUserName() ?? "";
    // laod content first - get friends, requests and groups
    return FutureBuilder<void>(
        future: Future.wait([
          getFriends(username),
          getFriendRequests(username),
          getMyGroups(username),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20.0),
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
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            leading: FirebaseStorageImage(
                              profileUrl:
                                  SharedPrefs().getProfileUrl() as String,
                            ),
                            trailing: const Icon(Icons.settings,
                                color: Colors.white, size: 26),
                            onTap: () {
                              // handleTap(context, 2);
                              try {
                                Application.router
                                    .navigateTo(context, "/profile");
                              } catch (e) {
                                print(
                                    '\nIn sidebar, after clikcing on settings icon, Error navigating to Profile: $e\n');
                              }
                            },
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10.0),
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
                      child:
                          const Icon(Icons.add, color: Colors.black, size: 25),
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
                          itemCount: friends.length,
                          itemBuilder: (BuildContext context, int index) {
                            User friend = friends[index];
                            String friendUsername = friend.username;

// if you click the friendname, go to the friendship page. Can i send friend groupId? load it here?
                            return ListTile(
                                title: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(this.context,
                                        '/friendship?friendUsername=$friendUsername');
                                  },
                                  child: Text(
                                    friend.username,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                leading: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Profile(user: friend),
                                          ),
                                        );
                                      },
                                      child: FirebaseStorageImage(
                                        profileUrl: friend.profilePicture,
                                        user: friend,
                                      ),
                                    )));
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
                      child:
                          const Icon(Icons.add, color: Colors.black, size: 25),
                    ),
                    initiallyExpanded: false,

                    shape: Border(),
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: groupnamesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            String groupname = groupnamesList[index];
                            int? groupId = userGroups[index].id;
// go to group with this Id
                            return ListTile(
                              title: Text(
                                groupname,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              leading: Icon(Icons.people, color: Colors.black),
                              onTap: () {
                                Navigator.pushNamed(this.context,
                                    '/myGroup?groupName=$groupname&groupId=$groupId');
                              },
                            );
                          },
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
                    trailing: friendRequests.isNotEmpty
                        ? const Icon(Icons.pending,
                            color: Colors.orange, size: 25)
                        : const Icon(Icons.pending,
                            color: Colors.black, size: 25),
                    shape: const Border(),
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: friendRequests.length,
                          itemBuilder: (BuildContext context, int index) {
                            // List<String> requestsList =
                            //     friendRequestUsernames.toList();
                            User requester = friendRequests[index];

                            return ListTile(
                              title: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Profile(user: requester)),
                                  );
                                },
                                child: Text(
                                  requester.username,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              leading: FirebaseStorageImage(
                                profileUrl: requester.profilePicture,
                                user: requester,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      handleFriendRequests(
                                          username, requester.username, true);
                                      setState(() {
                                        friendRequests.remove(requester);
                                      });
                                    },
                                    child: const Icon(Icons.check_box,
                                        color: Colors.black),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      handleFriendRequests(
                                          username, requester.username, false);
                                      setState(() {
                                        friendRequests.remove(requester);
                                      });
                                    },
                                    child: const Icon(Icons.cancel,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              onTap:
                                  () {}, // Keep this empty if onTap behavior is handled by GestureDetector
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: .1),
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
    case 2: // "Profile"
      Navigator.pushNamed(context, '/profile');
      break;

    case 3: // "Logout"
      Navigator.pushNamed(context, '/logout');
      break;

    case 4: // "Create Group"
      Navigator.pushNamed(context, '/create_group');
      break;
  }
}
