import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/create_group_app_bar.dart';
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

class createGroup extends StatefulWidget {
  createGroup({
    Key? key,
  }) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<createGroup> {
  String username = SharedPrefs().getUserName() ?? "";
  bool isCreated = false; // in the beginning, the group isn't created
  TextEditingController responseController = TextEditingController();
  String userResponse = '';

  // search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  List<String> friendsUsernamesList = [];
  List<String> addedUsernames = []; //usernames added to the group

  bool friendsFetched = false;

//Find my friends!

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

  void toggleFriend(String friendName) {
    if (addedUsernames.contains(friendName)) {
      addedUsernames.remove(friendName);
      //do nothing
    } else {
      addedUsernames.add(friendName);
      print('added $friendName to addedusernames');
    }
  }

  /* send create group request to backend 
   
  Create Group
      path = "api/v1/createGroup"
    Request: 
    String groupName
    String creatingUsername
    List<String> addedUsernames

  
   */

  //set up the search controller
  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
    if (!friendsFetched) {
      // wait to load
      Future.wait([
        getFriends(username),
      ]).then((_) {
        //  friendsUsernamesList; //display all friends
        setState(() {});
      });
    }
  }

//dispose of search controller
  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  // search feature control (adjust if necessary)
  List<String> _searchResults() {
    return friendsUsernamesList
        .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  Widget build(BuildContext context) {
    String username = SharedPrefs().getUserName() ?? "";

    final String assetName = 'assets/img1.svg'; // orange (top) background

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

                          // appbar on top of orange background
                          groupAppBar(title: 'Create Group'),

                          // don't show the search bar in 'nameGroup' mode
                          Visibility(
                            visible: !isCreated,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                    width: 350,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ), // search bar
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          )
                        ]))
                  ]),
                ),

                // constant background
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
                            color: const Color.fromARGB(255, 117, 19, 12)
                                .withOpacity(0.5),
                            blurRadius: 5,
                            offset: Offset(3, 7),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          // first stage: adding users
                          if (!isCreated)
                            Expanded(

                                // if you are searching for friends, display those results
                                child: _searchText.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: _searchResults().length,
                                        itemBuilder: (context, index) {
                                          final name = _searchResults()[
                                              index]; //username of each listing
                                          final isAdded =
                                              addedUsernames.contains(name);
                                          if (!isCreated) {
                                            // bool to control whether you have already added them
                                            return ListTile(
                                              title: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons
                                                      .mood), // prof pic of user
                                                  SizedBox(width: 8),
                                                  Text(
                                                    name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon:
                                                    isAdded // if they're added then show this
                                                        ? Icon(Icons.pending)
                                                        : Icon(Icons
                                                            .person_add_alt),
                                                onPressed: () {
                                                  if (!isAdded) {
                                                    // prevent user from sending friend requests twice!

                                                    setState(() {
                                                      toggleFriend(name);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      toggleFriend(name);
                                                    });
                                                  }
                                                },
                                              ),

                                              // icon displayed is dependent on whether you have requested this user.
                                            );
                                          }
                                        },
                                      )
                                    // if not searching, display all friends
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0, top: 14.0),
                                                child: Text(
                                                  "All Friends",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount:
                                                    friendsUsernamesList.length,
                                                itemBuilder: (context, index) {
                                                  final name =
                                                      friendsUsernamesList[
                                                          index];
                                                  final isAdded =
                                                      addedUsernames.contains(
                                                          name); // bool to control whether you have already added them

                                                  return ListTile(
                                                    title: Row(
                                                      children: [
                                                        Icon(Icons.mood),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: IconButton(
                                                      icon:
                                                          isAdded // if they're added then show this
                                                              ? Icon(
                                                                  Icons.pending)
                                                              : Icon(Icons
                                                                  .person_add_alt),
                                                      onPressed: () {
                                                        if (!isAdded) {
                                                          // prevent user from sending friend requests twice
                                                          setState(() {
                                                            toggleFriend(name);
                                                          });
                                                        } else {
                                                          setState(() {
                                                            toggleFriend(name);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ]))
                          else
                            // if it is created then you are making your group!
                            Column(children: [
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
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                                'Added Usernames: $addedUsernames ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ]),
                        ],
                      )),
                ),

                SizedBox(height: 16.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // if the group hasn't been created, bring back to global challenge
                        if (!isCreated) {
                          handleTap(context, 0);
                        } else {
                          // if we're in name group, go back to create group
                          setState(() {
                            isCreated = false; // shift content
                          });
                        }
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
                      // display different text based on which 'stage' we're in
                      child: Text(
                        isCreated ? 'Back' : 'Cancel',
                        style: TextStyle(
                          color: Color(0xFFE76F51),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // if group isn't created, create it
                        if (!isCreated) {
                          setState(() {
                            isCreated = true; // shift content
                          });
                          // otherwise, take us to the group page
                        } else {
                          handleTap(context, 1,
                              userResponse: userResponse,
                              addedUsernames: addedUsernames);
                        }
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
              ]))),
      drawer: SideBar(),
    ));
  }
}

/* 
create group:

case 0: go back to global challenge 'cancel'
case 1: isCreated = true 'next'

name group: 

case 0: go back to create group with same users selected
- isCreated = false 'back'
case 1: create the group 'create group'



*/

void handleTap(BuildContext context, int index,
    {String? userResponse, List<String>? addedUsernames}) {
  switch (index) {
    // !isCreated
    case 0: // "Global Challenge"
      // ignore: prefer_typing_uninitialized_variables
      Navigator.pushNamed(context, '/global_challenge');
      break;
    // is created

    // take us to the group page! (eventually)
    case 1:
      print('here');
      print(addedUsernames);
      print(userResponse);
      Navigator.pushNamed(
        context,
        '/my_group',
        arguments: {
          'groupName': userResponse,
          'addedUsernames': addedUsernames,
        },
      );
      break;
  }
}
