import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/screens/sideBar.dart';
import 'package:verbatim_frontend/widgets/customAppBar_Settings.dart';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';
import 'package:verbatim_frontend/widgets/friends_app_bar_test.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/widgets/stats.dart';
import 'package:verbatim_frontend/widgets/stats_tile.dart';
import 'package:verbatim_frontend/screens/settings.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  final User? user; // Optional User object

  const Profile({Key? key, this.user}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String assetName = 'assets/img1.svg';
  final String profile = 'assets/default.jpeg';
  final String friendsIcon = 'assets/friends.svg';
  final String streakIcon = 'assets/streak.svg';
  final String globalChallengeIcon = 'assets/globalChallenges.svg';
  final String customIcon = 'assets/customChallenges.svg';

  static int friends = -1;
  static int globals = 0;
  static int customs = 0;
  static int streaks = 0;

  List<int> stats = [friends, globals, customs, streaks];

  String firstName = '';
  String lastName = '';
  String initial = '';

  String displayName = '';
  String username = '';

  String bio = '';
  String profileUrl = 'assets/profile_pic.png';
  Map<String, bool> friendRequestStates = {};

  Future<void> _getStats(String username) async {
    final url = Uri.parse("${BackendService.getBackendUrl()}getUserStats");
    final headers = <String, String>{'Content-Type': 'application/json'};
    final getStats = await http.post(url, headers: headers, body: username);

    if (getStats.statusCode == 200) {
      final List<dynamic>? data = jsonDecode(getStats.body);
      streaks = data![0];
      customs = data[1];
      globals = data[2];
      friends = data[3];
    } else {
      print('Sorry could not get user stats');
    }
  }

  Future<void> sendFriendRequest(
      String requestingUsername, String requestedUsername) async {
    print(
        "\n\nRequester: ${requestingUsername} while the requested: ${requestedUsername}\n");
    final url = Uri.parse(BackendService.getBackendUrl() + 'addFriend');
    final headers = <String, String>{'Content-Type': 'application/json'};

    final response = await http.post(url,
        headers: headers,
        body: json.encode({
          "requestingUsername": requestingUsername,
          "requestedUsername": requestedUsername
        }));
    if (response.statusCode == 200) {
      _showSuccessDialog();
      setState(() {
        friendRequestStates[requestedUsername] =
            true; // Update request state for the user
      });

      print(
          '\nresponses sent successfully: $requestingUsername and $requestedUsername\n');
    } else {
      print('Failed to send responses. Status code: ${response.statusCode}');
    }
  }

  Future<void> getUsersIHaveRequested(String username) async {
    final url =
        Uri.parse(BackendService.getBackendUrl() + 'getUsersIHaveRequested');
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set the corner radius
          ),
          backgroundColor: const Color.fromARGB(
              255, 255, 243, 238), // Set the background color
          title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Verba',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '-tastic!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          content: const Text(
            'Your friend request has been sent!',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
            ), // Set text color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Poppins',
                ), // Set button text color
              ),
            ),
          ],
        );
      },
    );
  }

  final String field = "Friend";
  @override
  void initState() {
    super.initState();
    getUsersIHaveRequested(SharedPrefs().getUserName() as String);

    if (!friendRequestStates.containsKey(widget.user!.username)) {
      friendRequestStates[widget.user!.username] = widget.user!.isRequested;
    }

    print("\nAfter calling getUsers.. here is the map: ${friendRequestStates}");

    // If user object is provided, populate profile details from user object
    if (widget.user != null) {
      if (widget.user!.bio == null) {
        widget.user!.bio = " ";
      }
      firstName = widget.user!.firstName.replaceFirst(
          widget.user!.firstName[0], widget.user!.firstName[0].toUpperCase());

      lastName = widget.user!.lastName;
      initial = lastName.substring(0, 1).toUpperCase();
      displayName = '$firstName $initial.';
      username = widget.user!.username;
      bio = widget.user!.bio as String ?? " ";
      // Ensure profileUrl is assigned 'assets/profile_pic.png' if widget.user!.profilePicture is null
      profileUrl = widget.user!.profilePicture ?? 'assets/profile_pic.png';
    } else {
      // If user object is null, fetch details from SharedPrefs
      firstName = SharedPrefs().getFirstName() ?? "User";
      lastName = SharedPrefs().getLastName() ?? "Name";
      initial = lastName.substring(0, 1);
      displayName = '$firstName $initial.';
      username = SharedPrefs().getUserName() ?? " ";
      bio = SharedPrefs().getBio() ?? " ";
      profileUrl = SharedPrefs().getProfileUrl() ?? 'assets/profile_pic.png';
    }
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
                height: 932,
                width: 430,
                color: Color.fromRGBO(255, 243, 238, 1),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160,
                            width: 430,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                // Orange background
                                Container(
                                  height: 160,
                                  width: 430,
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  child: SvgPicture.asset(
                                    assetName,
                                    fit: BoxFit.fill,
                                  ),
                                ),

                                const SizedBox(width: 10),
                                CustomAppBarSettings(title: '')
                              ],
                            ),
                          ),
                          Card(
                            elevation: 2,
                            color: Colors.white,
                            shadowColor: Color(0xFFE76F51).withOpacity(0.2),
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
                                      Container(
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
                                                final currentUserUsername =
                                                    widget.user!.username;
                                                if (widget.user == null) {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        settings(),
                                                  ));
                                                } else {
                                                  if (friendRequestStates[
                                                          currentUserUsername] ==
                                                      false) {
                                                    await sendFriendRequest(
                                                        SharedPrefs()
                                                                .getUserName()
                                                            as String,
                                                        widget.user!.username);
                                                  } else {
                                                    print(
                                                        "\n\n Map is ${friendRequestStates}");
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
                                                  color: Color(0xFFE76F51),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  shadows: [
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
                                                      final currentUserUsername =
                                                          widget.user!.username;
                                                      if (widget.user == null) {
                                                        // Navigate to settings
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              settings(),
                                                        ));
                                                      } else {
                                                        if (friendRequestStates[
                                                                currentUserUsername] ==
                                                            false) {
                                                          sendFriendRequest(
                                                              SharedPrefs()
                                                                      .getUserName()
                                                                  as String,
                                                              widget.user!
                                                                  .username);
                                                        } else {
                                                          print(
                                                              "\n\n Map is ${friendRequestStates}");
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
                                                              BoxDecoration(),
                                                          child: Stack(
                                                            children: [
                                                              if (widget.user !=
                                                                      null &&
                                                                  friendRequestStates[widget
                                                                          .user!
                                                                          .username] ==
                                                                      true)
                                                                Icon(
                                                                  Icons
                                                                      .person_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                ),
                                                              if (widget.user !=
                                                                      null &&
                                                                  friendRequestStates[widget
                                                                          .user!
                                                                          .username] ==
                                                                      false)
                                                                Icon(
                                                                  Icons
                                                                      .person_add_alt_outlined,
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
                                                                    TextStyle(
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
                            shadowColor: Color(0xFFE76F51),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              width: 360,
                              height: 470,
                              padding: EdgeInsets.all(25),
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
                                  Positioned(
                                      child: Center(
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
                                  )),

                                  const SizedBox(height: 5),

                                  const Positioned(
                                    child: Center(
                                      child: Text(
                                        "86% similarity",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        widthFactor: .5,
                                        child: ClipOval(
                                          child: widget.user != null
                                              ? Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: FirebaseStorageImage(
                                                    profileUrl: SharedPrefs()
                                                            .getProfileUrl()
                                                        as String,
                                                  ),
                                                )
                                              : Container(
                                                  width: 100,
                                                  height: 100,
                                                  color: Colors.blue,
                                                ),
                                        ),
                                      ),
                                      Align(
                                        widthFactor: .5,
                                        child: ClipOval(
                                          child: widget.user != null
                                              ? Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: FirebaseStorageImage(
                                                    profileUrl: widget
                                                        .user!.profilePicture,
                                                  ),
                                                )
                                              : Container(
                                                  width: 100,
                                                  height: 100,
                                                  color: Colors.red,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          drawer: SideBar(),
          drawerScrimColor: Colors.white,
        ),
      ),
    );
  }
}
