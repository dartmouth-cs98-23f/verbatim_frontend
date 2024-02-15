import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/screens/sideBar.dart';
import 'package:verbatim_frontend/widgets/center_custom_app_bar.dart';
import 'package:verbatim_frontend/widgets/custom_challenge_button.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';
import 'package:verbatim_frontend/widgets/showSuccessDialog.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/widgets/stats_tile.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Stats {
  final dynamic streaks;
  final dynamic customs;
  final dynamic globals;
  final dynamic friends;
  final dynamic match;
  final dynamic verbaMatchScore;
  Stats({
    required this.streaks,
    required this.customs,
    required this.globals,
    required this.friends,
    required this.match,
    required this.verbaMatchScore,
  });
  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      streaks: json['streak'],
      customs: json['groupChalllengesCompleted'],
      globals: json['globalChallengesCompleted'],
      friends: json['numFriends'],
      match: json['verbaMatchUser'],
      verbaMatchScore: json['verbaMatchScore'],
    );
  }
}

class Profile extends StatefulWidget {
  final User? user; // Optional User object

  const Profile({Key? key, this.user}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String assetName = 'assets/img1.svg';
  // final String profile = 'assets/default.jpeg';
  final String friendsIcon = 'assets/friends.svg';
  final String streakIcon = 'assets/streak.svg';
  final String globalChallengeIcon = 'assets/globalChallenges.svg';
  final String customIcon = 'assets/customChallenges.svg';
  User? match;

  List<int> stats = [friends, globals, customs, streaks];

  String firstName = '';
  String lastName = '';
  String initial = '';

  String displayName = '';
  String username = '';

  String bio = '';
  String profileUrl = 'assets/profile_pic.png';
  Map<String, bool> friendRequestStates = {};
  bool drawButton = false;
  String groupName = '';
  User? toBeDisplayedUser;

  static int friends = 0;
  static int globals = 0;
  static int customs = 0;
  static int streaks = 0;
  static double verbaMatchScore = 0;
  static String profile = 'assets/default.jpeg';

  Future<void> _getStats(String username) async {
    final url =
        Uri.parse("${BackendService.getBackendUrl()}$username/getUserStats");
    final headers = <String, String>{'Content-Type': 'application/json'};
    final getStats = await http.get(url, headers: headers);

    if (getStats.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(getStats.body);
      final Stats stats = Stats.fromJson(data);

      friends = stats.friends;
      globals = stats.globals;
      customs = stats.customs;
      streaks = stats.streaks;
      verbaMatchScore = stats.verbaMatchScore;

      if (verbaMatchScore == -1) {
        verbaMatchScore = 0;
      }

      final Map<String, dynamic> matchDeets = stats.match;

      // Remove the current user's details from matchDeets
      matchDeets.removeWhere((key, value) =>
          key == 'username' && value == SharedPrefs().getUserName() as String);

      // Set match to null if matchDeets still contains elements
      User? newMatch = matchDeets.isEmpty
          ? null
          : User(
              username: matchDeets["username"],
              bio: matchDeets['bio'],
              id: matchDeets['id'],
              email: matchDeets['email'],
              lastName: matchDeets['lastName'],
              firstName: matchDeets['firstName'],
              profilePicture: matchDeets['profilePicture'],
              numGlobalChallengesCompleted:
                  matchDeets['numGlobalChallengesCompleted'],
              numCustomChallengesCompleted:
                  matchDeets['numCustomChallengesCompleted'],
              streak: matchDeets['streak'],
              hasCompletedDailyChallenge:
                  matchDeets['hasCompletedDailyChallenge'],
            );

      setState(() {
        match = newMatch;
      });

      // Print statements for debugging (can be removed in production)
      print("\nVerba match score: $verbaMatchScore\n");
      print("\nMatch user: $match\n");
      print("\nMatchDeets : $matchDeets\n");
      print("\nStats.match is : ${stats.match}\n");
    } else {
      print(
          'Error: Could not fetch user stats. Status code: ${getStats.statusCode}');
      // Handle other status codes appropriately
    }
  }

  Future<void> sendFriendRequest(
      String requestingUsername, String requestedUsername) async {
    final url = Uri.parse('${BackendService.getBackendUrl()}addFriend');
    final headers = <String, String>{'Content-Type': 'application/json'};

    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          "requestingUsername": requestingUsername,
          "requestedUsername": requestedUsername
        }));
    if (response.statusCode == 200) {
      SuccessDialog.show(context, 'Your friend request has been sent!');
      setState(() {
        friendRequestStates[requestedUsername] = true;
        drawButton = true;
      });
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  Future<void> getUsersIHaveRequested(String username) async {
    final url =
        Uri.parse('${BackendService.getBackendUrl()}getUsersIHaveRequested');
    final Map<String, String> headers = {
      'Content-Type': 'text/plain',
    };

    final response = await http.post(url, headers: headers, body: username);

    if (response.statusCode == 200) {
      List<dynamic> myfriendRequests = json.decode(response.body);
      if (myfriendRequests.isNotEmpty) {
        for (var request in myfriendRequests) {
          String requestedUsername = request['username'];
          // Set the friend request state to true for each user requested
          friendRequestStates[requestedUsername] = true;
        }
      }
    } else {
      print(
          '\nIn addFriends getUsersIHaveRequested: Failed to send responses. Status code: ${response.statusCode}\n');
    }
  }

  final String field = "Friend";
  @override
  void initState() {
    super.initState();
    getUsersIHaveRequested(SharedPrefs().getUserName() as String);

    if (widget.user != null) {
      if (!friendRequestStates.containsKey(widget.user!.username)) {
        friendRequestStates[widget.user!.username] = widget.user!.isRequested;
      }
      drawButton = friendRequestStates[widget.user!.username] as bool;
      groupName = '${SharedPrefs().getUserName()}&${widget.user!.username}';
    }

    // Initialize username from SharedPrefs if not provided through the widget
    username = widget.user?.username ?? SharedPrefs().getUserName() ?? " ";

    // Initialize bio, ensuring it's never null
    bio = widget.user?.bio ?? SharedPrefs().getBio() ?? " ";

    // Initialize profileUrl, ensuring a default is used if null
    profileUrl = widget.user?.profilePicture ??
        SharedPrefs().getProfileUrl() ??
        'assets/profile_pic.png';

    // Populate the initial values for other user details
    firstName =
        (widget.user?.firstName ?? SharedPrefs().getFirstName() ?? "User")
            .replaceFirstMapped(
      RegExp(r'^\w'),
      (match) => match
          .group(0)!
          .toUpperCase(), // Ensures the first letter of first name is capitalized.
    );

    lastName = widget.user?.lastName ?? SharedPrefs().getLastName() ?? "Name";
    initial = lastName.isNotEmpty ? lastName.substring(0, 1).toUpperCase() : "";

    // Format displayName using firstName and initial
    displayName = lastName.isNotEmpty ? '$firstName $initial.' : firstName;
    _getStats(username).then((_) {
      setState(() {
        stats = [friends, streaks, globals, customs];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Theme(
        data: ThemeData(
          // Set the color of the drawer icon
          primaryColor: Colors.white, // Change to your desired color

          // Remove the shadow when hovering over the drawer
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                color: const Color.fromRGBO(255, 243, 238, 1),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160,
                            width: double.maxFinite,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                // Orange background
                                Container(
                                  height: 160,
                                  width: double.maxFinite,
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  child: SvgPicture.asset(
                                    assetName,
                                    fit: BoxFit.fill,
                                  ),
                                ),

                                const SizedBox(width: 10),
                                const centerAppBar(
                                  title: 'Public Profile',
                                ),
                              ],
                            ),
                          ),
                          Card(
                            elevation: 2,
                            color: Colors.white,
                            shadowColor:
                                const Color(0xFFE76F51).withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              width: 360,
                              height: 190,
                              padding: const EdgeInsets.only(top: 25, left: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 101.12,
                                        child: ClipOval(
                                          child: FirebaseStorageImage(
                                              profileUrl: profileUrl),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: [
                                          Text(
                                            softWrap: true,
                                            displayName,
                                            style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 32)),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SafeArea(
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (widget.user == null) {
                                                  Navigator.pushNamed(
                                                      context, '/settings');
                                                } else {
                                                  if (friendRequestStates[widget
                                                          .user!.username] ==
                                                      false) {
                                                    await sendFriendRequest(
                                                        SharedPrefs()
                                                                .getUserName()
                                                            as String,
                                                        widget.user!.username);
                                                  } else {
                                                    print(
                                                        "\n\n Map is $friendRequestStates");
                                                    print(
                                                        "\n33 User's username is ${widget.user!.username}");
                                                    print(
                                                        "\nImplement the method to handle when the user is already a friend or the FR has been sent!\n");
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: 200,
                                                height: 25,
                                                decoration: ShapeDecoration(
                                                  color:
                                                      const Color(0xFFE76F51),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  shadows: const [
                                                    BoxShadow(
                                                      color: Color(0x3F000000),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                      spreadRadius: 0,
                                                    )
                                                  ],
                                                ),
                                                child: Material(
                                                  // Use Material widget to enable ink splash
                                                  color: Colors
                                                      .transparent, // Make it transparent to prevent background color overlay
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (widget.user == null) {
                                                        // Navigate to settings
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/settings');
                                                      } else {
                                                        if (friendRequestStates[
                                                                widget.user!
                                                                    .username] ==
                                                            false) {
                                                          sendFriendRequest(
                                                              SharedPrefs()
                                                                      .getUserName()
                                                                  as String,
                                                              widget.user!
                                                                  .username);
                                                        } else {
                                                          print(
                                                              "\n\n Map is $friendRequestStates");
                                                          print(
                                                              "\n33 User's username is ${widget.user!.username}");

                                                          print(
                                                              "\nImplement the method to handle when the user is already a friend or the FR has been sent!\n");
                                                        }
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: widget.user !=
                                                                  null
                                                              ? 20
                                                              : 0, // Set width to 0 when user is null
                                                          height: 20,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration:
                                                              const BoxDecoration(),
                                                          child: Stack(
                                                            children: [
                                                              // Display person_outlined icon when there is a user and friend request is accepted
                                                              if (widget.user !=
                                                                      null &&
                                                                  friendRequestStates[widget
                                                                          .user!
                                                                          .username] ==
                                                                      true)
                                                                const Icon(
                                                                  Icons
                                                                      .person_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                ),

                                                              // Display person_add_alt_outlined icon when there is a user and friend request is not sent/accepted
                                                              if (widget.user !=
                                                                      null &&
                                                                  friendRequestStates[widget
                                                                          .user!
                                                                          .username] ==
                                                                      false)
                                                                const Icon(
                                                                  Icons
                                                                      .person_add_alt_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                ),

                                                              // Display create_outlined icon when there is no user object (i.e., widget.user is null)
                                                              if (widget.user ==
                                                                  null)
                                                                const Icon(
                                                                  Icons
                                                                      .create_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Center(
                                                            child: Text(
                                                              widget.user ==
                                                                      null
                                                                  ? "Edit Profile"
                                                                  : friendRequestStates[widget
                                                                              .user!
                                                                              .username] ==
                                                                          true
                                                                      ? "Friends Since ${DateFormat('MM/dd/yy').format(DateTime.now())}"
                                                                      : "Add Friend",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      textStyle: widget.user ==
                                                                              null
                                                                          ? const TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600,
                                                                              height: 0.12,
                                                                              letterSpacing: 0.20,
                                                                            )
                                                                          : const TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600,
                                                                              height: 0.12,
                                                                              letterSpacing: 0.20,
                                                                            )),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  // Bio

                                  Text(
                                    bio ?? "Bio goes here",
                                    softWrap: true,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Stats tile
                          Card(
                            elevation: 4,
                            color: Colors.white,
                            shadowColor: const Color(0xFFE76F51),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              width: 360,
                              height: 470,
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                    width: 15,
                                  ),

                                  Text(
                                    "User Stats",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),
                                  Row(children: <Widget>[
                                    Expanded(
                                        child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 231, 111, 81),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              spreadRadius: 2.0,
                                              blurRadius: 5.0,
                                              offset: const Offset(0, 2),
                                            )
                                          ]),
                                      child: MyStatsTile(
                                          field: "Friends",
                                          stat: (stats[0]).toString(),
                                          icon: friendsIcon),
                                    )),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 231, 111, 81),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              spreadRadius: 2.0,
                                              blurRadius: 5.0,
                                              offset: const Offset(0, 2),
                                            )
                                          ]),
                                      child: MyStatsTile(
                                          field: "Current \nStreak",
                                          stat: stats[1].toString(),
                                          icon: streakIcon),
                                    )),
                                  ]),

                                  const SizedBox(height: 10),

                                  Row(children: <Widget>[
                                    Expanded(
                                        child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 231, 111, 81),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              spreadRadius: 2.0,
                                              blurRadius: 5.0,
                                              offset: const Offset(0, 2),
                                            )
                                          ]),
                                      child: MyStatsTile(
                                          field: "Global \nChallenges",
                                          stat: stats[2].toString(),
                                          icon: globalChallengeIcon),
                                    )),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 231, 111, 81),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              spreadRadius: 2.0,
                                              blurRadius: 5.0,
                                              offset: const Offset(0, 2),
                                            )
                                          ]),
                                      child: MyStatsTile(
                                          field: "Custom \nChallenges",
                                          stat: stats[3].toString(),
                                          icon: customIcon),
                                    )),
                                  ]),
                                  // Profile picture
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text.rich(TextSpan(
                                      children: [
                                        TextSpan(
                                          text: widget.user == null
                                              ? 'Highest '
                                              : (friendRequestStates[widget
                                                          .user!.username] ==
                                                      true
                                                  ? 'Your '
                                                  : 'Highest '),
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                            text: 'Verba',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 231, 111, 81),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        TextSpan(
                                            text: 'Match',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )),
                                  ),

                                  const SizedBox(height: 10),

                                  (match != null || widget.user != null)
                                      ? Center(
                                          child: Text.rich(TextSpan(
                                            children: [
                                              TextSpan(
                                                text: (verbaMatchScore != -1
                                                        ? verbaMatchScore
                                                        : 0)
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: "% similarity",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          )),
                                        )
                                      : Container(),

                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        widthFactor: .5,
                                        child: ClipOval(
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: FirebaseStorageImage(
                                              profileUrl: SharedPrefs()
                                                  .getProfileUrl() as String,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              25), // Add spacing between the profile pictures
                                      Align(
                                        widthFactor: .5,
                                        child: ClipOval(
                                          child: widget.user != null
                                              ? SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: FirebaseStorageImage(
                                                    profileUrl: widget
                                                        .user!.profilePicture,
                                                    user: widget.user,
                                                  ),
                                                )
                                              : match != null
                                                  ? SizedBox(
                                                      width: 100,
                                                      height: 100,
                                                      child:
                                                          FirebaseStorageImage(
                                                        profileUrl: match!
                                                            .profilePicture,
                                                        user: match,
                                                      ),
                                                    )
                                                  : const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Icon(
                                                        Icons.help_outline,
                                                        size: 110,
                                                        color:
                                                            Color(0xFFE76F51),
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          CustomChallengeButton(
                            drawButton: drawButton,
                            groupName: groupName,
                          ),
                          const SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          drawer: const SideBar(),
        ),
      ),
    );
  }
}
