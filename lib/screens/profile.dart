import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
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
  const Profile({Key? key}) : super(key: key);

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

  static String firstName = SharedPrefs().getFirstName() ?? "User";
  static String lastName = SharedPrefs().getLastName() ?? "Name";
  static String initial = lastName.substring(0, 1);

  String displayName = '$firstName $initial.';
  final String username = SharedPrefs().getUserName() ?? " ";

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

  final String field = "Friend";
  @override
  void initState() {
    super.initState();
    _getStats(username).then((_) {
      setState(() {
        stats = [friends, streaks, globals, customs];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              //color: Color.fromRGBO(255, 243, 238, 1),
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250.v,
                          width: double.maxFinite,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              // Orange background
                              Container(
                                height: 250.v,
                                width: double.maxFinite,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                child: SvgPicture.asset(
                                  assetName,
                                  fit: BoxFit.fill,
                                ),
                              ),

                              // App bar on top of background
                              CustomAppBar(),
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
                            width: 340,
                            height: 200,
                            padding: const EdgeInsets.only(top: 25, left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100.v,
                                      height: 100.v,
                                      child: ClipOval(
                                        child: Image.asset(
                                          profile,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover, //TODO CHANGE THIS
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      children: [
                                        Text(
                                          softWrap: true,
                                          displayName,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 32)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SafeArea(
                                          child: GestureDetector(
                                            onTap: () {
                                              // Navigate to settings
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    settings(),
                                              ));
                                              //func
                                            },
                                            child: Container(
                                              width: 120,
                                              height: 25,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFE76F51),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              child: Material(
                                                // Use Material widget to enable ink splash
                                                color: Colors
                                                    .transparent, // Make it transparent to prevent background color overlay
                                                child: InkWell(
                                                  onTap: () {
                                                    // Navigate to the settings page
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          settings(),
                                                    ));
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
                                                      //SizedBox(width: 10),
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Center(
                                                          child: Text(
                                                            "Edit Profile",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                  SharedPrefs().getBio() ?? "Bio goes here",
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
                            width: 340,
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
                                            color: Colors.black.withOpacity(.2),
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
                                            color: Colors.black.withOpacity(.2),
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
                                            color: Colors.black.withOpacity(.2),
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
                                            color: Colors.black.withOpacity(.2),
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
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      TextSpan(
                                          text: 'Verba',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 231, 111, 81),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      TextSpan(
                                          text: 'Match',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
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
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      widthFactor: .5,
                                      child: ClipOval(
                                        child: Container(
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
      ),
    );
  }
}
