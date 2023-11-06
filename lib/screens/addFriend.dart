import 'package:flutter/material.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
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
  bool usersFetched = false;
  List<User> users = [];
  List<String> userUsernames = [];
  List<String> friendsUsernamesList = [];
  List<String> requestingUsers = [];
  // all of the user's that aren't friends with this user - need via backend

  List<String> _selectedFriends = [];

// suggested - need to add some logic here
  List<String> _suggestedNames = [
    "Eve Wening",
    "George Wening",
  ];

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
          requestingUsers.add(username);
        }
        print('this is requesting users $requestingUsers');
      }
    } else {
      print(username);
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

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

      print('this is friends: $friendsUsernamesList');

      print(response);
    } else {
      print(username);
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

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
      print("failureeeeee");
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
      getFriends(widget.username);
      getUsers();
      getFriendRequests(widget.username);

      usersFetched = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFriend(String friendName) {
    setState(() {
      if (_selectedFriends.contains(friendName)) {
        _selectedFriends.remove(friendName);
      } else {
        _selectedFriends.add(friendName);
        sendFriendRequest(widget.username, friendName);
      }
    });
  }

  List<String> _searchResults() {
    return userUsernames
        .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

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
      print("'$requestingUsername' has requested '$requestedUsername'");
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  Widget build(BuildContext context) {
    userUsernames.removeWhere((item) => friendsUsernamesList.contains(item));
    userUsernames.removeWhere((item) => requestingUsers.contains(item));
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
                          FriendsAppBar(),

                          Padding(
                            padding: EdgeInsets.only(
                                top:
                                    20.0), // Adjust the top padding value as needed
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: 350,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
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
                                            hintText: "Search User",
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
                    child: _searchText.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults().length,
                            itemBuilder: (context, index) {
                              final friendName = _searchResults()[index];
                              final isFriend =
                                  _selectedFriends.contains(friendName);
                              return ListTile(
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.mood),
                                      SizedBox(width: 8),
                                      Text(
                                        friendName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: isFriend
                                        ? Icon(Icons.pending)
                                        : requestingUsers.contains(friendName)
                                            ? Icon(Icons.check_box,
                                                color: Colors.black)
                                            : Icon(Icons.person_add_alt),
                                    onPressed: () {
                                      _toggleFriend(friendName);
                                    },
                                  ));
                            },
                          )
                        : ListView.builder(
                            itemCount: userUsernames.length,
                            itemBuilder: (context, index) {
                              final name = userUsernames[index];
                              final isFriend = _selectedFriends.contains(name);

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
                                    icon: isFriend
                                        ? Icon(Icons.pending)
                                        : requestingUsers.contains(name)
                                            ? Icon(Icons.check_box,
                                                color: Colors.black)
                                            : Icon(Icons.person_add_alt),
                                    onPressed: () {
                                      _toggleFriend(name);
                                    },
                                  ));
                            },
                          ),
                  ),
                ),
              ],
            )),
      ),
      drawer: SideBar(username: widget.username),
    ));
  }
}
