import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/defineRoutes.dart';
import 'dart:convert';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/screens/profile.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';
import 'package:confetti/confetti.dart';

class UserGroup {
  int id = 0;
  String groupName = "";

  UserGroup({required this.groupName, required this.id});

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(groupName: json['name'], id: json['id']);
  }
}

class FriendRequestsIcon extends StatefulWidget {
  final Color iconColor;

  const FriendRequestsIcon({Key? key, required this.iconColor})
      : super(key: key);

  @override
  _FriendRequestsIconState createState() => _FriendRequestsIconState();
}

class _FriendRequestsIconState extends State<FriendRequestsIcon> {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.pending, color: widget.iconColor, size: 25);
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
  Color trailingIconColor = Colors.black;
  String username = SharedPrefs().getUserName() as String;
  late ConfettiController _confettiController;

  final String firstName =
      (SharedPrefs().getUserName() as String).replaceFirstMapped(
    RegExp(r'^\w'),
    (match) => match
        .group(0)!
        .toUpperCase(), // Ensures the first letter of first name is capitalized.
  );

  String lastNameInitial = (SharedPrefs().getLastName() ?? "Name").isNotEmpty
      ? (SharedPrefs().getLastName() ?? "Name").substring(0, 1).toUpperCase()
      : "";

  // String displayName = (SharedPrefs().getLastName() ?? "Name").isNotEmpty ? '$firstName $lastNameInitial.' : '$firstName';

  final Color primary = const Color.fromARGB(255, 231, 111, 81);
  bool showFriends = false;
  bool showGroups = false;
  bool showFriendRequests = false;

  List<User> friendRequests = [];
  List<User> friends = [];
  List<String> groupnamesList = [];
  List<UserGroup> userGroups = [];
  Map<int, List<User>> groupMemberObjects = {};
  List<String> groupMembers = [];

  final formUri = Uri.parse(
      'https://docs.google.com/forms/d/e/1FAIpQLSdcfcWUuU19auQXU0Jj_s--x4t_lVPVvOWqURWgP49z1HWZaA/viewform');

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getGroupStats(int groupId) async {
    print("\ngroupId here is $groupId\n");
    final url = Uri.parse('${BackendService.getBackendUrl()}group/$groupId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      print("this is groupstats json code $jsonData");
      double rating = jsonData["groupRating"];
      print("this is the rating in mygroup $rating");

      List<dynamic> verbaMatchList = jsonData["verbaMatch"];
      List<String> usernames = [];
      for (var item in verbaMatchList) {
        usernames.add(item["username"]);
      }
      groupMembers = List<String>.from(jsonData["groupMembers"]);

      await getGroupMemberObjects(groupId, groupMembers);

      print(
          "\nHere in getGroupStats, groupMemberObjects contains ${groupMemberObjects.length} objects\n");
    } else {
      print('failed to get group stats. Status code: ${response.statusCode}');
    }
  }

  // get all users to display
  Future<void> getGroupMemberObjects(
      int groupId, List<String> groupMembersList) async {
    final url = Uri.parse('${BackendService.getBackendUrl()}users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final List<User> userList =
          data.map((item) => User.fromJson(item)).toList();

      // Filter users based on groupMembersList and modify groupMemberObjects
      groupMemberObjects[groupId] = userList
          .where((user) => groupMembersList.contains(user.username))
          .toList();

      groupMemberObjects.forEach((groupId, memberObjects) {
        for (var member in memberObjects) {
          member.isRequested = true;
        }
      });
    } else {
      print("Failure: ${response.statusCode}");
      // Handle failure if needed
    }
  }

  //get groups
  Future<void> getMyGroups(String username) async {
    final url =
        Uri.parse('${BackendService.getBackendUrl()}user/$username/groups');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> groups = data['groups'];

      for (Map<String, dynamic> group in groups) {
        int id = group["id"];
        String name = group["name"];
        userGroups.add(UserGroup(id: id, groupName: name));
        groupnamesList.add(name);

        getGroupStats(id);
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
      for (var user in friends) {
        user.isRequested = true;
      }
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
      if (friendRequests.isNotEmpty) {
        trailingIconColor = Colors.orange;
      }
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
      setState(() {
        getFriends(username);
      });
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  void _triggerConfettiAnimation() {
    _confettiController.play();
  }

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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
                              (SharedPrefs().getLastName() ?? "Name").isNotEmpty
                                  ? '$firstName $lastNameInitial.'
                                  : firstName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold),
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
                                fontFamily: 'Poppins',
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
                            fontFamily: 'Poppins',
                            fontSize: 18)),

                    // takes you to the addFriend page
                    trailing: GestureDetector(
                      onTap: () {
                        handleTap(context, 1);
                      },
                      child:
                          const Icon(Icons.add, color: Colors.black, size: 25),
                    ),

                    initiallyExpanded: true, //showFriends,

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
                                    friend.username.replaceFirstMapped(
                                      RegExp(r'^\w'),
                                      (match) => match
                                          .group(0)!
                                          .toUpperCase(), // Ensures the first letter of first name is capitalized.
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                leading: Container(
                                    decoration: const BoxDecoration(
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
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    maxBlastForce: 20, // Adjust the blast force as needed
                    minBlastForce: 8, // Adjust the blast force as needed
                    emissionFrequency:
                        0.05, // Adjust the frequency of confetti emission
                    numberOfParticles:
                        50, // Adjust the number of confetti particles
                    gravity: 0.05, // Adjust the gravity of confetti particles
                    shouldLoop:
                        false, // Set to true if you want the confetti to loop
                    colors: const [
                      Colors.blue,
                      Colors.green,
                      Colors.pink
                    ], // Add your desired confetti colors
                  ),
                  const SizedBox(height: 20.0),
                  ExpansionTile(
                    title: const Text(
                      'Groups',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
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

                    shape: const Border(),
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: groupnamesList.length,
                        itemBuilder: (context, index) {
                          final groupname = groupnamesList[index];
                          final groupId = userGroups[index].id;
                          final memberObjects =
                              groupMemberObjects[groupId] ?? [];

                          print("\nMember objects are ${memberObjects}\n");

                          return ListTile(
                            title: Row(
                              children: [
                                // If you want the images to appear before the text, keep this block here
                                SizedBox(
                                  width: 20.0 +
                                      min(memberObjects.length, 6) *
                                          20.0, // Adjust based on the number of images
                                  height: 30.0, // Height to accommodate images
                                  child: Stack(
                                    children: [
                                      for (int i = 0;
                                          i < min(memberObjects.length, 6);
                                          i++) // Show max 3 images
                                        Positioned(
                                          top: 0.0,
                                          left: i *
                                              20.0, // Adjust spacing as needed
                                          child: SizedBox(
                                            width: 30.0, // Image width
                                            height: 30.0, // Image height
                                            child: ClipOval(
                                              child: FirebaseStorageImage(
                                                profileUrl: memberObjects[i]
                                                    .profilePicture,
                                                user: memberObjects[i],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Spacer or sized box can be added here if needed
                                Expanded(
                                  child: Text(
                                    groupname,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/myGroup?groupName=$groupname&groupId=$groupId',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text(
                      'Friend Requests',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 18),
                    ),
                    //   trailing: FriendRequestsIcon(iconColor: trailingIconColor),

                    trailing: trailingIconColor == Colors.orange
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
                                    fontFamily: 'Poppins',
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
                                  /*GestureDetector(
                                    onTap: () {
                                      _showAcceptDeclineDialog(context,
                                          (accepted) {
                                        setState(() {
                                          friendRequests.remove(requester);
                                          if (friendRequests.isNotEmpty) {
                                            trailingIconColor = Colors.orange;
                                          } else {
                                            trailingIconColor = Colors.black;
                                          }
                                          if (accepted) {
                                            handleFriendRequests(username,
                                                requester.username, true);
                                          } else {
                                            handleFriendRequests(username,
                                                requester.username, false);
                                          }
                                        });
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Image.asset('assets/decision.png'),
                                      radius: 18,
                                    ),
                                  ),*/
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        friendRequests.remove(requester);
                                        if (friendRequests.isNotEmpty) {
                                          trailingIconColor = Colors.orange;
                                        } else {
                                          trailingIconColor = Colors.black;
                                        }
                                      });
                                      setState(() {
                                        handleFriendRequests(
                                            username, requester.username, true);
                                      });
                                    },
                                    child: const Icon(Icons.check_box,
                                        color: Colors.black),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        friendRequests.remove(requester);
                                        if (friendRequests.isNotEmpty) {
                                          trailingIconColor = Colors.orange;
                                        } else {
                                          trailingIconColor = Colors.black;
                                        }

                                        setState(() {
                                          handleFriendRequests(username,
                                              requester.username, false);
                                        });
                                        // friendRequests.remove(requester);
                                      });
                                    },
                                    child: const Icon(Icons.cancel,
                                        color: Colors.black),
                                  ),

                                  /*
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        friendRequests.remove(requester);
                                        handleFriendRequests(
                                            username, requester.username, true);
                                      });
                                    },
                                    child: const Icon(Icons.check_box,
                                        color: Colors.black),
                                  ),
                                  */

                                  /*
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        handleFriendRequests(username,
                                            requester.username, false);

                                        // friendRequests.remove(requester);
                                      });
                                    },
                                    child: const Icon(Icons.cancel,
                                        color: Colors.black),
                                  ),
                                  */
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
                  const SizedBox(height: 10.0),
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
                                fontFamily: 'Poppins',
                                fontSize: 18)),
                        onTap: () {
                          Navigator.pushNamed(context, '/logout');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: ListTile(
                      title: const Text(
                        'Questions? Feedback? Click Here!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        _launchURL(formUri);
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                  Container(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: const Center(
                      child: ListTile(
                        title: Text(
                          'Made with love, by the Verbatim team.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              fontSize: 15),
                        ),
                        leading: Icon(Icons.favorite,
                            color: Colors.red, size: 17 // Set the color to red
                            ),
                        trailing: Icon(Icons.favorite,
                            color: Colors.red, size: 17 // Set the color to red
                            ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 10),
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
