import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/profile.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';
import 'package:verbatim_frontend/widgets/friends_app_bar.dart';
import 'package:verbatim_frontend/widgets/friends_app_bar_test.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Update User class
class User {
  int id = 0;
  String email = "";
  String username = "";
  String lastName = "";
  String firstName = "";
  dynamic profilePicture;
  String? bio = "";
  int numGlobalChallengesCompleted = 0;
  int numCustomChallengesCompleted = 0;
  int streak = 0;
  bool hasCompletedDailyChallenge = false;
  bool isRequested = false;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.lastName,
    required this.firstName,
    required this.profilePicture,
    required this.bio,
    required this.numGlobalChallengesCompleted,
    required this.numCustomChallengesCompleted,
    required this.streak,
    required this.hasCompletedDailyChallenge,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      profilePicture: json['profilePicture'],
      bio: json['bio'],
      numGlobalChallengesCompleted: json['numGlobalChallengesCompleted'],
      numCustomChallengesCompleted: json['numCustomChallengesCompleted'],
      streak: json['streak'],
      hasCompletedDailyChallenge: json['hasCompletedDailyChallenge'],
    );
  }
}

class addFriend extends StatefulWidget {
  addFriend({
    Key? key,
  }) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<addFriend> {
  String username = SharedPrefs().getUserName() ?? "";
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  bool usersFetched = false; // only call users once per run
  List<User> users = []; // all users
  List<String> userUsernames = []; // all user usernames to display
  List<String> friendsUsernamesList =
      []; // friends (remove from user usernames)
  List<String> requestingUsers =
      []; // people who have requested current user (remove form user usernames)
  List<String> myRequestedUsers_backend =
      []; // GET THESE FROM THE BACKEND, THEN ADD THEM TO THE PROVIDER
  List<User> searchResults = []; // User objects corresponding to search results
  List<User> friendsList = []; // User objects corresponding to friends

  // suggested - need to add the logic here - not yet implemented
  List<String> _suggestedNames = [];

  // get friend requests to build list of requesting users, to remove
  // from displayed users (to avoid crash on requesting again)
  Future<void> getFriendRequests(String username) async {
    final url = Uri.parse(BackendService.getBackendUrl() + 'getFriendRequests');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
      print('getfriendrequests responses sent succesfully');

      List<Map<String, dynamic>> friendRequests =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      if (friendRequests.isNotEmpty) {
        for (var request in friendRequests) {
          String username = request['username'];
          requestingUsers.add(username);
        }
      }
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  void toggleFriend(String friendName) {
    if (myRequestedUsers_backend.contains(friendName)) {
      //do nothing
    } else {
      myRequestedUsers_backend.add(friendName);
    }
  }

  // get the friend requests that i have sent
  Future<void> getUsersIHaveRequested(String username) async {
    final url =
        Uri.parse(BackendService.getBackendUrl() + 'getUsersIHaveRequested');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
      print(
          'myRequestedUsers_backend responses sent succesfully $myRequestedUsers_backend');

      List<Map<String, dynamic>> myfriendRequests =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      if (myfriendRequests.isNotEmpty) {
        for (var request in myfriendRequests) {
          String username = request['username'];
          myRequestedUsers_backend.add(username);
        }
      }
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  // get friends to remove from displayed users
  Future<void> getFriends(String username) async {
    final url = Uri.parse(BackendService.getBackendUrl() + 'getFriends');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
      print('responses sent succesfully');
      final List<dynamic> data = json.decode(response.body);
      List<User> friendsList = data.map((item) => User.fromJson(item)).toList();
      friendsUsernamesList = friendsList.map((user) => user.username).toList();
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  // get all users to display
  Future<void> getUsers() async {
    final url = Uri.parse(BackendService.getBackendUrl() + 'users');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("response succesfull");
      final List<dynamic> data = json.decode(response.body);
      final List<User> userList =
          data.map((item) => User.fromJson(item)).toList();

      userUsernames = userList
          .where((user) => user.username != username)
          .map((user) => user.username)
          .toList();

      searchResults = userList
          .where((user) => user.username != username)
          .map((user) => user)
          .toList();

      setState(() {
        users = userList;
      });
    } else {
      print("failure");
    }
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
    if (!usersFetched) {
      // wait to load
      Future.wait([
        getFriends(username),
        getUsers(),
        getFriendRequests(username),
        getUsersIHaveRequested(username),
      ]).then((_) {
        userUsernames
            .removeWhere((item) => friendsUsernamesList.contains(item));
        userUsernames.removeWhere((item) => requestingUsers.contains(item));

        // Filter searchResults list to remove user objects based on friendsUsernamesList and requestingUsers
        searchResults.removeWhere((user) =>
            friendsUsernamesList.contains(user.username) ||
            requestingUsers.contains(user.username));

        // Filter users based on search text and friends
        searchResults = users
            .where((user) =>
                user.username.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();
        friendsList = users
            .where((user) => friendsUsernamesList.contains(user.username))
            .toList();

        usersFetched = true;

        setState(() {});
      });
    }
  }

  // check for changes
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!usersFetched) {
      Future.wait([
        getFriends(username),
        getUsers(),
        getFriendRequests(username),
        getUsersIHaveRequested(username),
      ]).then((_) {
        userUsernames
            .removeWhere((item) => friendsUsernamesList.contains(item));
        userUsernames.removeWhere((item) => requestingUsers.contains(item));

        searchResults.removeWhere((user) =>
            friendsUsernamesList.contains(user.username) ||
            requestingUsers.contains(user.username));

        usersFetched = true;

        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  // search feature control (adjust if necessary)
  List<User> _searchResults() {
    // return userUsernames
    //     .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
    //     .toList();

    return searchResults
        .where((item) =>
            item.username.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  // send friendrequest to backend
  Future<void> sendFriendRequest(
      String requestingUsername, String requestedUsername) async {
    final url = Uri.parse(BackendService.getBackendUrl() + 'addFriend');
    final headers = <String, String>{'Content-Type': 'application/json'};

    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          "requestingUsername": requestingUsername,
          "requestedUsername": requestedUsername
        }));
    if (response.statusCode == 200) {
      print('responses sent succesfully');
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  Widget build(BuildContext context) {
    String username = SharedPrefs().getUserName() ?? "";

    final String assetName = 'assets/img1.svg';

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 255, 243, 238),
      body: SingleChildScrollView(
        child: Container(
            color: Color.fromARGB(255, 255, 243, 238),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 240.v,
                        width: double.maxFinite,
                        child: Stack(alignment: Alignment.topCenter, children: [
                          // orange background
                          Container(
                            // height: 220.v,
                            // width: double.maxFinite,
                            height: 261,
                            width: 430,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              assetName,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // app bar for add friend page
                          FriendsAppBarTest(
                            title: 'Add Friends',
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: 357,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  // search bar
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 8),
                                      Icon(Icons.search, color: Colors.black),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            hintStyle: const TextStyle(
                                                fontSize: 14.0,
                                                color: Color.fromARGB(
                                                    255, 6, 5, 5)),
                                            border: InputBorder.none,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),

                          // search results
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Container(
                          height: 22,
                          width: 190,
                          child: Text(
                            _searchText.isEmpty
                                ? 'People you may know'
                                : 'Search Results',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0.09,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // box in which search results will appear
                Center(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(top: 10),
                    // width: 300.h,
                    // height: 500.v,
                    width: 335,
                    height: 508,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 117, 19, 12)
                              .withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(3, 7),
                        ),
                      ],
                      color: Colors.white,
                    ),

                    // when user searches, display relevant items
                    child: _searchText.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults().length,
                            itemBuilder: (context, index) {
                              final currentUser = _searchResults()[index];
                              final name = currentUser.username;
                              currentUser.isRequested =
                                  myRequestedUsers_backend.contains(name);
                              String profileUrl = currentUser.profilePicture;

                              return ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FirebaseStorageImage(
                                      profileUrl: profileUrl,
                                      user: currentUser,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                // icon displayed is dependent on whether you have requested this user.
                                trailing: IconButton(
                                  icon: currentUser.isRequested
                                      ? Icon(Icons.pending)
                                      : Icon(Icons.person_add_alt),
                                  onPressed: () {
                                    if (!currentUser.isRequested) {
                                      // prevent user from sending friend requests twice!
                                      sendFriendRequest(username, name);

                                      setState(() {
                                        toggleFriend(name);
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: userUsernames.length,
                            itemBuilder: (context, index) {
                              // final name = userUsernames[index];
                              final currentUser = searchResults[index];
                              final name = currentUser.username;

                              currentUser.isRequested =
                                  myRequestedUsers_backend.contains(name);
                              String profileUrl = currentUser.profilePicture;
                              return ListTile(
                                title: Row(
                                  children: [
                                    FirebaseStorageImage(
                                      profileUrl: profileUrl,
                                      user: currentUser,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: currentUser.isRequested
                                      ? Icon(Icons.pending)
                                      : Icon(Icons.person_add_alt),
                                  onPressed: () {
                                    if (!currentUser.isRequested) {
                                      sendFriendRequest(username, name);
                                      setState(() {
                                        toggleFriend(name);
                                        myRequestedUsers_backend.add(
                                            name); // keeps the icon from changing if you navigate away from the page
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            )),
      ),
    ));
  }
}
