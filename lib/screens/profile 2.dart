import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/widgets/stats.dart';
import 'package:verbatim_frontend/widgets/stats_tile.dart';
import 'package:verbatim_frontend/screens/settings.dart';

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

  static const String friends = "54";
  static const String globals = "";
  static const String customs = "";
  static const String streaks = "";

  final String field = "Friend";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Color.fromARGB(255, 255, 243, 238),
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
                                color: Colors.transparent,
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
                            width: 300.h,
                            height: 200.v,
                            padding: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100.v,
                                      height: 100.v,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
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
                                          SharedPrefs().getFirstName() ??
                                              "User M.",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 32),
                                        ),
                                        SizedBox(
                                          height: 15,
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
                                              height: 30,
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
                                                  child: const Row(
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
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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

                                const SizedBox(height: 25),

                                // Bio
                                Text(
                                  SharedPrefs().getBio() ?? "Bio goes here",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
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
                            width: 300.h,
                            height: 450.v,
                            padding: EdgeInsets.all(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                  width: 15,
                                ),

                                const Text(
                                  "User Stats",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    height: 75.v,
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
                                        field: "friends",
                                        stat: "54",
                                        icon: friendsIcon),
                                  )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: 75.v,
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
                                        field: "Current streak",
                                        stat: "19",
                                        icon: streakIcon),
                                  )),
                                ]),

                                const SizedBox(height: 15),

                                Row(children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    height: 75.v,
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
                                        field: "Global Challenges",
                                        stat: "103",
                                        icon: globalChallengeIcon),
                                  )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: 75.v,
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
                                        field: "Custom Challenges",
                                        stat: "358",
                                        icon: customIcon),
                                  )),
                                ]),
                                // Profile picture
                                const SizedBox(height: 15),
                                const Positioned(
                                    child: Center(
                                  child: Text.rich(TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Your',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: ' Verba',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 231, 111, 81),
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: 'Match',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                )),

                                const SizedBox(height: 10),

                                const Positioned(
                                  child: Center(
                                    child: Text(
                                      "86% similarity",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
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
