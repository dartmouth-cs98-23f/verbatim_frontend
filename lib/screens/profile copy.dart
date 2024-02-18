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
  User? ownMatch;
  User? otherMatch;

  List<int> stats = [friends, globals, customs, streaks];

  String firstName = '';
  String lastName = '';
  String initial = '';

  String displayName = '';
  String username = '';

  String bio = '';
  String profileUrl = '';
  // Map<String, bool> friendRequestStates = {};
  bool drawButton = false;
  String groupName = '';
  User? toBeDisplayedUser;
  String friendshipDate = '';
  String friendshipStatusDescription = "Friend Request Pending";
  String ownProfileUrl =
      SharedPrefs().getProfileUrl() ?? 'assets/profile_pic.png';
  String otherProfileUrl = 'assets/profile_pic.png';

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
      final Stats stats = Stats.fromJson(jsonDecode(getStats.body));

      friends = stats.friends;
      globals = stats.globals;
      customs = stats.customs;
      streaks = stats.streaks;
      verbaMatchScore = stats.verbaMatchScore;

      print("this is verbamatch score $verbaMatchScore");

      if (verbaMatchScore == -1) {
        verbaMatchScore = 0;
      }

      final Map<String, dynamic> matchDeets = stats.match;

      print("this is match deets $matchDeets");
      // Remove the current user's details from matchDeets

      print("\nthis is match deets after remove where $matchDeets");

      // Set match to null if matchDeets still contains elements
      User? newMatch =
          matchDeets["username"] == SharedPrefs().getUserName() as String
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
      print("newmatch username: ");
      print(newMatch?.username);

      newMatch?.profilePicture ??= 'assets/profile_pic.png';

      print(newMatch?.profilePicture);
      setState(() {
        if (username == SharedPrefs().getUserName() as String) {
          ownMatch = newMatch;
          print("\nOwnMatch username: ${ownMatch!.username}\n");
        } else {
          otherMatch = newMatch;
          print("\nOtherMatch username: ${otherMatch!.username}\n");
        }
      });

      // Print statements for debugging (can be removed in production)
      print("\nVerba match score: $verbaMatchScore\n");
      print("\nownMatch user: $ownMatch\n");
      print("\otherMatch user: $ownMatch\n");

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
        widget.user!.isRequested =
            true; // Update the friend request status of this user once the friend request is sent.
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

    dynamic responsedecode = json.decode(response.body);
    print("this is responsedecode $responsedecode");
    if (response.statusCode == 200) {
      print("im in =200");
      List<dynamic> myfriendRequests = json.decode(response.body);
      print("these are myfriendreqeusts $myfriendRequests");
      if (myfriendRequests.isNotEmpty) {
        for (var request in myfriendRequests) {
          String requestedUsername = request['username'];
          // Set the friend request state to true if the other user is among the ones who were sent a friend request by the current user
          if (widget.user!.username == request['username']) {
            widget.user!.isRequested = true;
          }
        }
      }
    } else {
      print(
          '\nIn addFriends getUsersIHaveRequested: Failed to send responses. Status code: ${response.statusCode}\n');
    }
  }

  void getFriendshipDate(String currentUsername, String friendUsername) async {
    final String url =
        "${BackendService.getBackendUrl()}${currentUsername}/${friendUsername}/getUserStats";

    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON string
        Map<String, dynamic>? friendshipJson = jsonDecode(response.body);

        // Check if the key exists and its value is not null
        String? friendsSince = friendshipJson?['friendsSince'];

        if (friendsSince != null) {
          // Parse the original date string
          DateTime dateTime = DateFormat("MM-dd-yyyy").parse(friendsSince);

          // Format the date in the desired format
          friendshipDate = DateFormat("MM/dd/yy").format(dateTime);

          print('\nFriendship Date: $friendshipDate\n');
        } else {
          print(
              '\nError: "friendsSince" is null or not found in JSON response\n');
        }
      } else {
        print(
            '\nFailed to get friendship data. Status code: ${response.statusCode}\n');
      }

      if (friendshipDate.isNotEmpty) {
        friendshipStatusDescription = "Friends Since ${friendshipDate}";
      }
    } catch (error) {
      print('\nError getting friendship data: $error\n');
    }
  }

  final String field = "Friend";
  @override
  void initState() {
    super.initState();
    getUsersIHaveRequested(SharedPrefs().getUserName() as String);
// if this is someone else's page then draw the ''requested'' button as such
    if (widget.user != null) {
      otherProfileUrl = widget.user!.profilePicture;
      drawButton = widget.user!.isFriend;
      groupName = '${widget.user!.username}';
    }

    // Initialize username from SharedPrefs if not provided through the widget
    username = widget.user?.username ?? SharedPrefs().getUserName() ?? " ";

    // Initialize bio, ensuring it's never null
    bio = widget.user?.bio ?? SharedPrefs().getBio() ?? " ";

    // Initialize profileUrl, ensuring a default is used if null
    profileUrl = widget.user?.profilePicture ??
        SharedPrefs().getProfileUrl() ??
        'assets/profile_pic.png';

    print("\nprofileURl $profileUrl");
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

    if (widget.user != null) {
      getFriendshipDate(
          SharedPrefs().getUserName() as String, widget.user!.username);
    }

    // Format displayName using firstName and initial
    displayName = lastName.isNotEmpty ? '$firstName $initial.' : firstName;
    _getStats(username).then((_) {
      setState(() {
        stats = [friends, streaks, globals, customs];
      });
    });

    if (widget.user != null) {
      _getStats(widget.user!.username).then((_) {
        setState(() {
          stats = [friends, streaks, globals, customs];
        });
      });
    }
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
                                              fontSize: 29,
                                              fontFamily: 'Poppins',
                                            )),
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
                                                  if (!widget
                                                          .user!.isRequested &&
                                                      !widget.user!.isFriend) {
                                                    widget.user!.isRequested =
                                                        true;
                                                    print(
                                                        "\nFrnd req sent: -> Frnd req status: ${widget.user!.isRequested} & frndship status: ${widget.user!.isFriend}\n");
                                                    await sendFriendRequest(
                                                        SharedPrefs()
                                                                .getUserName()
                                                            as String,
                                                        widget.user!.username);
                                                  } else {
                                                    print(
                                                        "\nNo frnd req sent: -> Frnd req status: ${widget.user!.isRequested} & frndship status: ${widget.user!.isFriend}\n");

                                                    print(
                                                        "\nUser's username is ${widget.user!.username}");
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
                                                        if (!widget.user!
                                                                .isRequested &&
                                                            !widget.user!
                                                                .isFriend) {
                                                          sendFriendRequest(
                                                              SharedPrefs()
                                                                      .getUserName()
                                                                  as String,
                                                              widget.user!
                                                                  .username);
                                                        } else {
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
                                                                  (widget.user!
                                                                          .isRequested ||
                                                                      widget
                                                                          .user!
                                                                          .isFriend))
                                                                const Icon(
                                                                  Icons
                                                                      .person_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                ),

                                                              // Display person_add_alt_outlined icon when there is a user and friend request is not sent
                                                              if (widget.user !=
                                                                      null &&
                                                                  !widget.user!
                                                                      .isRequested)
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
                                                                  : (widget.user!
                                                                              .isRequested ||
                                                                          widget
                                                                              .user!
                                                                              .isFriend)
                                                                      ? friendshipStatusDescription
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
                                                                              fontFamily: 'Poppins',
                                                                            )
                                                                          : const TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600,
                                                                              height: 0.12,
                                                                              letterSpacing: 0.20,
                                                                              fontFamily: 'Poppins',
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
                                        fontFamily: 'Poppins',
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
                              height: 500,
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
                                        fontFamily: 'Poppins',
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
                                              : (widget.user!.isFriend
                                                  ? 'Your '
                                                  : 'Highest '),
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins',
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
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            )),
                                        TextSpan(
                                            text: 'Match',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            )),
                                      ],
                                    )),
                                  ),

                                  const SizedBox(height: 10),

                                  // If there is a match and we are on the friend's profile
                                  (ownMatch != null ||
                                          widget.user != null ||
                                          otherMatch != null)
                                      ? Center(
                                          // Show the similarity score
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
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              const TextSpan(
                                                text: "% similarity",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontFamily: 'Poppins',
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
                                              profileUrl:
                                                  (widget.user == null ||
                                                          widget.user!.isFriend)
                                                      ? ownProfileUrl
                                                      : otherProfileUrl,
                                              user: (widget.user == null ||
                                                      widget.user!.isFriend)
                                                  ? null
                                                  : widget.user!,
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
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: (widget.user != null &&
                                                    widget.user!.isFriend)
                                                ? FirebaseStorageImage(
                                                    profileUrl: widget
                                                        .user!.profilePicture,
                                                    user: widget.user!,
                                                  )
                                                : (ownMatch != null &&
                                                        widget.user == null)
                                                    ? FirebaseStorageImage(
                                                        profileUrl: ownMatch!
                                                            .profilePicture,
                                                        user: ownMatch!,
                                                      )
                                                    : (otherMatch != null &&
                                                            !widget
                                                                .user!.isFriend
                                                        ? FirebaseStorageImage(
                                                            profileUrl: otherMatch!
                                                                .profilePicture,
                                                            user: otherMatch,
                                                          )
                                                        : Icon(
                                                            Icons.help_outline,
                                                            size: 110,
                                                            color: Color(
                                                                0xFFE76F51),
                                                          )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                      height:
                                          10), // Add spacing between the row and the text

                                  // Add the name of the verbamatched user if available
                                  Text(
                                    widget.user != null &&
                                            widget.user!
                                                .isFriend // If we are on a friend's profile, show their name
                                        ? "You and ${widget.user!.username.replaceFirstMapped(
                                            RegExp(r'^\w'),
                                            (match) =>
                                                match.group(0)!.toUpperCase(),
                                          )}" // Ensures the first letter of username is capitalized.
                                        : '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins'),
                                  ),

                                  Text(
                                    (widget.user == null &&
                                            ownMatch !=
                                                null) // If we are on our own profile and there is a match
                                        ? "You and ${ownMatch!.username.replaceFirstMapped(
                                            RegExp(r'^\w'),
                                            (match) =>
                                                match.group(0)!.toUpperCase(),
                                          )}" // Ensures the first letter of username is capitalized.
                                        : widget.user != null &&
                                                !widget.user!
                                                    .isFriend // If we are on a stranger's profile and they have a verbaMatch
                                            ? otherMatch != null
                                                ? "${widget.user!.username.replaceFirstMapped(
                                                    RegExp(r'^\w'),
                                                    (match) => match
                                                        .group(0)!
                                                        .toUpperCase(),
                                                  )} and ${otherMatch!.username.replaceFirstMapped(
                                                    RegExp(r'^\w'),
                                                    (match) => match
                                                        .group(0)!
                                                        .toUpperCase(),
                                                  )}"
                                                : ''
                                            : '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          // Only allow the user to create custom challenge with a friend.
                          (friendshipDate.isNotEmpty)
                              ? CustomChallengeButton(
                                  drawButton: drawButton,
                                  groupName: groupName,
                                )
                              : Container(),
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