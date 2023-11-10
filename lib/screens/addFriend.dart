import 'package:flutter/material.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/friends_app_bar.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// User class for when backend passes in users
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

class addFriend extends StatefulWidget {
  final String username = SharedPrefs().getUserName() ?? "";

  addFriend({
    Key? key,
  }) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<addFriend> {
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

// suggested - need to add the logic here - not yet implemented
  List<String> _suggestedNames = [];

// get friend requests to build list of requesting users, to remove
// from displayed users (to avoid crash on requesting again)
  Future<void> getFriendRequests(String username) async {
    final url = Uri.parse('http://localhost:8080/api/v1/getFriendRequests');
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
        Uri.parse('http://localhost:8080/api/v1/getUsersIHaveRequested');
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
    final url = Uri.parse('http://localhost:8080/api/v1/getFriends');
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
    final url = Uri.parse('http://localhost:8080/api/v1/users');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("response succesfull");
      final List<dynamic> data = json.decode(response.body);
      final List<User> userList =
          data.map((item) => User.fromJson(item)).toList();

      userUsernames = userList
          .where((user) => user.username != widget.username)
          .map((user) => user.username)
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
        getFriends(widget.username),
        getUsers(),
        getFriendRequests(widget.username),
        getUsersIHaveRequested(widget.username),
      ]).then((_) {
        userUsernames
            .removeWhere((item) => friendsUsernamesList.contains(item));
        userUsernames.removeWhere((item) => requestingUsers.contains(item));

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
        getFriends(widget.username),
        getUsers(),
        getFriendRequests(widget.username),
        getUsersIHaveRequested(widget.username),
      ]).then((_) {
        userUsernames
            .removeWhere((item) => friendsUsernamesList.contains(item));
        userUsernames.removeWhere((item) => requestingUsers.contains(item));

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
  List<String> _searchResults() {
    return userUsernames
        .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

// send friendrequest to backend
  Future<void> sendFriendRequest(
      String requestingUsername, String requestedUsername) async {
    final url = Uri.parse('http://localhost:8080/api/v1/addFriend');
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
                            height: 220.v,
                            width: double.maxFinite,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              assetName,
                              fit: BoxFit.fill,
                            ),
                          ),
                          // app bar for add friend page
                          FriendsAppBar(),

                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: 350,
                                  height: 30,
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
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: 200,
                              margin: EdgeInsets.only(left: 32),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    if (_searchText.isNotEmpty)
                                      TextSpan(
                                        text: "Search Results",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    else
                                      // to display "suggested friends" once logic is implemented
                                      TextSpan(
                                        text: "People you may know:",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),

                // box in which search results will appear
                Center(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(top: 10),
                    width: 300.h,
                    height: 500.v,
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
                              final name = _searchResults()[index];
                              final isRequested =
                                  myRequestedUsers_backend.contains(name);
                              return ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.mood),
                                    SizedBox(width: 8),
                                    Text(
                                      name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),

                                // icon displayed is dependent on whether you have requested this user.
                                trailing: IconButton(
                                  icon: isRequested
                                      ? Icon(Icons.pending)
                                      : Icon(Icons.person_add_alt),
                                  onPressed: () {
                                    if (!isRequested) {
                                      // prevent user from sending friend requests twice!
                                      sendFriendRequest(widget.username, name);

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
                              final name = userUsernames[index];
                              final isRequested =
                                  myRequestedUsers_backend.contains(name);

                              return ListTile(
                                  title: Row(
                                    children: [
                                      Icon(Icons.mood),
                                      SizedBox(width: 8),
                                      Text(
                                        name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: isRequested
                                        ? Icon(Icons.pending)
                                        : Icon(Icons.person_add_alt),
                                    onPressed: () {
                                      if (!isRequested) {
                                        sendFriendRequest(
                                            widget.username, name);
                                        setState(() {
                                          toggleFriend(name);
                                          myRequestedUsers_backend.add(
                                              name); // keeps the icon from changing if you navigate away from the page
                                        });
                                      }
                                    },
                                  ));
                            },
                          ),
                  ),
                ),
              ],
            )),
      ),
      drawer: SideBar(),
    ));
  }
}
