import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:verbatim_frontend/screens/User.dart';
import 'package:verbatim_frontend/screens/sideBar.dart';
import 'package:verbatim_frontend/widgets/custom_challenge_button.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';
import 'package:verbatim_frontend/widgets/showSuccessDialog.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/widgets/stats_tile.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/widgets/center_custom_app_bar.dart';
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

  static int friends = 0;
  static int globals = 0;
  static int customs = 0;
  static int streaks = 0;
  static double verbaMatchScore = 0;
  static User match = User(
    username: '',
    bio: '',
    id: 0,
    email: '',
    lastName: '',
    firstName: '',
    profilePicture: '',
    numGlobalChallengesCompleted: 0,
    numCustomChallengesCompleted: 0,
    streak: 0,
    hasCompletedDailyChallenge: false,
  );
  static String profile = 'assets/default.jpeg';

  Future<void> _getStats(String username) async {
    final url =
        Uri.parse("${BackendService.getBackendUrl()}$username/getUserStats");
    final headers = <String, String>{'Content-Type': 'application/json'};
    final getStats = await http.get(url, headers: headers);
    if (getStats.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(getStats.body);
      print("this is stats data $data");
      final Stats stats = Stats.fromJson(data);
      print("this is stats $stats");
      friends = stats.friends;
      globals = stats.globals;
      customs = stats.customs;
      streaks = stats.streaks;
      verbaMatchScore = stats.verbaMatchScore;

      if (stats.match != null) {
        final Map<String, dynamic> matchDeets = stats.match;
        match = User(
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
          hasCompletedDailyChallenge: matchDeets['hasCompletedDailyChallenge'],
        );
      } else {
        print("stats.match is null");
      }

      if (match.bio == '') {
      } else {
        //TODO: match.getprofile
      }
      if (SharedPrefs().getBio() == '') {
      } else {
        //TODO: sharedprefs.getprofile
        profile = profile;
      }
      // print("Itsss okkkk");
    } else {
      print('Sorry could not get user stats');
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
      groupName = widget.user!.username;
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
        widget.user?.firstName ?? SharedPrefs().getFirstName() ?? "User";
    lastName = widget.user?.lastName ?? SharedPrefs().getLastName() ?? "Name";
    initial =
        lastName.isNotEmpty ? lastName.substring(0, 1).toUpperCase() : "U";

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
          primaryColor: Colors.white,

          // Remove the shadow when hovering over the drawer
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                color: const Color.fromARGB(255, 255, 243, 238),
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
                                //const CustomAppBarSettings(title: '')
                              ],
                            ),
                          ),
                          Card(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              width: 330,
                              height: 200,
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
                                                    fontSize: 30)),
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
                                                width: 180,
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
                                                                  : ((friendRequestStates[widget
                                                                              .user!
                                                                              .username] ==
                                                                          true)
                                                                      ? "Friends Since 10/27/23" // "Friends Since ${DateTime(2023, 12, 31).toString().substring(0, 10)}
                                                                      : "Add Friend"),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 0.12,
                                                                  letterSpacing:
                                                                      0.20,
                                                                ),
                                                              ),
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
                                  const SizedBox(height: 5),

                                  // bio
                                  // Bio
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  minHeight:
                                                      constraints.maxHeight),
                                              child: Text(
                                                bio ?? "Bio goes here",
                                                softWrap: true,
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  /*
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(
                                          bio ?? "Bio goes here",
                                          softWrap: true,
                                          //   overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  */
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
                              width: 330,
                              height: 470,
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  const SizedBox(height: 20),
                                  Center(
                                    child: Text.rich(TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Highest',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
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

                                  const SizedBox(height: 5),

                                  Center(
                                      child: Text.rich(TextSpan(
                                    children: [
                                      TextSpan(
                                        text: verbaMatchScore.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: "% similarity",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ))),

                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        widthFactor: .65,
                                        //looking at our own profile
                                        child: ClipOval(
                                            child: widget.user != null
                                                ? SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: FirebaseStorageImage(
                                                      profileUrl: SharedPrefs()
                                                              .getProfileUrl()
                                                          as String,
                                                    ),
                                                  )
                                                : SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: FirebaseStorageImage(
                                                      profileUrl: SharedPrefs()
                                                              .getProfileUrl()
                                                          as String,
                                                    ),
                                                  )

                                            // : Stack(
                                            //     children: [
                                            //       Align(
                                            //         alignment:
                                            //             Alignment.center,
                                            //         child: Container(
                                            //           width: 100,
                                            //           height: 100,
                                            //           decoration:
                                            //               BoxDecoration(
                                            //             shape:
                                            //                 BoxShape.circle,
                                            //             color: Color.fromARGB(
                                            //                 255,
                                            //                 231,
                                            //                 111,
                                            //                 81),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       Align(
                                            //         alignment:
                                            //             Alignment.center,
                                            //         child: Icon(
                                            //             Icons.help_outline,
                                            //             size: 100,
                                            //             color: Color.fromARGB(
                                            //                 255,
                                            //                 250,
                                            //                 192,
                                            //                 94)),
                                            //       ),
                                            //     ],
                                            //   ),
                                            ),
                                      ),
                                      Align(
                                        widthFactor: 1.3,
                                        child: ClipRect(
                                            child: widget.user != null
                                                ? SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: Center(
                                                        child: Text(
                                                            match.username)))
                                                /*
                                                    child: FirebaseStorageImage(
                                                      profileUrl:
                                                          match.profilePicture,
                                                    ),
                                                  )*/
                                                : SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: Text(match
                                                        .username))), /*SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: FirebaseStorageImage(
                                                      profileUrl:
                                                          match.profilePicture,
                                                    ),
                                                  )),
                                                  */
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