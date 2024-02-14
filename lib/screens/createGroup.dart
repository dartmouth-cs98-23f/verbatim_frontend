import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/create_group_app_bar.dart';
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
  const createGroup({
    Key? key,
  }) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<createGroup> {
  String username = SharedPrefs().getUserName() ?? "";
  bool error = false;
  bool error2 = false;
  bool isCreated = false; // in the beginning, the group isn't created
  TextEditingController responseController = TextEditingController();
  String userResponse = '';

  // search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  List<String> friendsUsernamesList = [];
  List<String> addedUsernames = []; //usernames added to the group

  bool friendsFetched = false;
  int? groupId = 0;

  // create group
  Future<Map<int?, bool>> create(String groupName, String createdByUsername,
      List<String> usernamesToAdd) async {
    final url = Uri.parse('${BackendService.getBackendUrl()}createGroup');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final requestPayload = json.encode({
      'groupName': groupName,
      'createdByUsername': createdByUsername,
      'usernamesToAdd': usernamesToAdd,
    });

    final response =
        await http.post(url, headers: headers, body: requestPayload);

    if (response.statusCode == 200) {
      print('responses from CREATE GROUP sent succesfully');
      final Map<String, dynamic> data = json.decode(response.body);

      print('this is create group data $data');
      groupId = data['groupId'];

      String groupName = data['groupName'];

      List<dynamic> users = data['users'];

      print('this is create group data $data');
      print('Group ID: $groupId');
      print('Group Name: $groupName');

      for (var user in users) {
        int userId = user['id'];
        String username = user['username'];
        String email = user['email'];
      }
      return {groupId: true};
    } else {
      return {groupId: false};
      print(
          'Failed to send responses.ok/??? Status code: ${response.statusCode}');
    }
  }

//Find my friends!

  Future<void> getFriends(String username) async {
    final url = Uri.parse('${BackendService.getBackendUrl()}getFriends');
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

  @override
  Widget build(BuildContext context) {
    String username = SharedPrefs().getUserName() ?? "";

    const String assetName = 'assets/img1.svg'; // orange (top) background

    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 243, 238),
      body: SingleChildScrollView(
          child: Container(
              color: const Color.fromARGB(255, 255, 243, 238),
              child: Column(children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Column(children: [
                    SizedBox(
                        height: 220,
                        width: double.maxFinite,
                        child: Stack(alignment: Alignment.topCenter, children: [
                          // orange background
                          Container(
                            height: 220,
                            width: double.maxFinite,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              assetName,
                              fit: BoxFit.fill,
                            ),
                          ),

                          // appbar on top of orange background
                          const groupAppBar(title: 'Create Group'),

                          // don't show the search bar in 'nameGroup' mode
                          Visibility(
                            visible: !isCreated,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
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
                                        const SizedBox(width: 8),
                                        const Icon(Icons.search, color: Colors.black),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextField(
                                            controller: _searchController,
                                            decoration: const InputDecoration(
                                              hintStyle: TextStyle(
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
                          ),
                        ]))
                  ]),
                ),
                Visibility(
                    visible: error,
                    child: Center(
                      child: SizedBox(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Add at least two friends to make a group",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                Visibility(
                    visible: error2,
                    child: Center(
                      child: SizedBox(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Error creating duplicate group - do you already have a group with these users?",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),

                // constant background
                Center(
                  child: Container(
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.only(top: 10),
                      width: 300,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 117, 19, 12)
                                .withOpacity(0.5),
                            blurRadius: 5,
                            offset: const Offset(3, 7),
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
                                                  const Icon(Icons
                                                      .mood), // prof pic of user
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon:
                                                    isAdded // if they're added then show this
                                                        ? const Icon(Icons.check)
                                                        : const Icon(Icons
                                                            .person_add_alt),
                                                onPressed: () {
                                                  if (!isAdded) {
                                                    // prevent user from sending friend requests twice!

                                                    setState(() {
                                                      toggleFriend(name);
                                                      error2 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      toggleFriend(name);
                                                      error2 = false;
                                                    });
                                                  }
                                                },
                                              ),

                                              // icon displayed is dependent on whether you have requested this user.
                                            );
                                          }
                                          return null;
                                        },
                                      )
                                    // if not searching, display all friends
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                            const Padding(
                                                padding: EdgeInsets.only(
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
                                                        const Icon(Icons.mood),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          name,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: IconButton(
                                                      icon:
                                                          isAdded // if they're added then show this
                                                              ? const Icon(
                                                                  Icons.check)
                                                              : const Icon(Icons
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
                              const SizedBox(height: 30),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  'Word! Give your group a name!',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: TextField(
                                  controller: responseController,
                                  onChanged: (value) {
                                    setState(() {
                                      userResponse = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Type your group name here...',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                            ]),
                        ],
                      )),
                ),

                const SizedBox(height: 16.0),

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
                            isCreated = false;
                            error2 = false; // shift content
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 243, 238),
                        padding: const EdgeInsets.all(16.0),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          //why doesnt this work  side: BorderSide(width: 20.0),
                        ),
                        minimumSize: const Size(100, 50),
                        side: const BorderSide(color: Color(0xFFE76F51)),
                      ),
                      // display different text based on which 'stage' we're in
                      child: Text(
                        isCreated ? 'Back' : 'Cancel',
                        style: const TextStyle(
                          color: Color(0xFFE76F51),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        // if group isn't created, create it
                        if (!isCreated) {
                          if (addedUsernames.length <= 1) {
                            setState(() {
                              error = true;
                              error2 = false; // shift content
                            });
                          } else {
                            setState(() {
                              error = false;
                              isCreated = true;
                              error2 = false; // shift content
                            });
                          }

                          // otherwise, take us to the group page
                        } else {
                          // talk to backend here
                          Map<int?, bool> result = await create(
                              userResponse, username, addedUsernames);
                          print("this is the result of group creation $result");
                          int? groupId = result.keys.first;
                          bool? created = result[groupId];
                          int groupID = groupId!;
                          if (created == true) {
                            print(
                                'this is the groupid in create group $groupId');
                            Navigator.pushNamed(this.context,
                                '/myGroup?groupName=$userResponse&groupId=$groupID');
                          } else {
                            setState(() {
                              error2 = true;
                              isCreated = true;
                              for (String x in addedUsernames) {
                                toggleFriend(x);
                              }

                              addedUsernames = []; // shift content
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE76F51),
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        minimumSize: const Size(100, 50),
                      ),
                      child: const Text(
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
      drawer: const SideBar(),
    ));
  }
}

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
      print(
          'Arguments in handleTap: groupName: $userResponse, addedUsernames: $addedUsernames');

      Navigator.pushNamed(
        context,
        '/my_group/${Uri.encodeComponent(userResponse!)}/${Uri.encodeComponent(addedUsernames!.join(','))}',
      );

/*
      Navigator.pushNamed(
        context,
        '/my_group',
        arguments: {
          'groupName': userResponse,
          'addedUsernames': addedUsernames,
        },
      );
      */

      break;
  }
}
