import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String assetName = 'assets/img1.svg';
  final String profile = 'assets/profile_pic.png';

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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            width: 300.h,
                            height: 250.v,
                            padding: EdgeInsets.all(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile picture
                                Container(
                                  width: 100.v,
                                  height: 100.v,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      profile,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16),

                                // Bio
                                Text(
                                  SharedPrefs().getBio() ?? "Verba-...",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Stats tile
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            width: 300.h,
                            height: 450.v,
                            padding: EdgeInsets.all(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),

                                const Text(
                                  "User Stats",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                Row(children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    height: 75.v,
                                    
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 231, 111, 81),
                                      borderRadius:BorderRadius.circular(15.0) ,

                                      boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.2),
                                        spreadRadius: 2.0,
                                        blurRadius: 5.0,
                                        offset: Offset(0, 2),
                                      )
                                    ]),
                                    child: const Text(
                                      "card test",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  )),

                                  SizedBox(width: 15,),

                                  Expanded(
                                      child: Container(
                                    height: 75.v,
                                    
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 231, 111, 81),
                                      borderRadius:BorderRadius.circular(15.0) ,
                                      boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.2),
                                        spreadRadius: 2.0,
                                        blurRadius: 5.0,
                                        offset: Offset(0, 2),
                                      )
                                    ]),
                                    child: const Text(
                                      "card test",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  )),
                                ]),

                                const SizedBox(height: 15),

                                Row(children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    height: 75.v,
                                    
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 231, 111, 81),
                                      borderRadius:BorderRadius.circular(15.0) ,

                                      boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.2),
                                        spreadRadius: 2.0,
                                        blurRadius: 5.0,
                                        offset: Offset(0, 2),
                                      )
                                    ]),
                                    child: const Text(
                                      "card test",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  )),

                                  SizedBox(width: 15,),

                                  Expanded(
                                      child: Container(
                                    height: 75.v,
                                    
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 231, 111, 81),
                                      borderRadius:BorderRadius.circular(15.0) ,
                                      boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.2),
                                        spreadRadius: 2.0,
                                        blurRadius: 5.0,
                                        offset: Offset(0, 2),
                                      )
                                    ]),
                                    child: const Text(
                                      "card test",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  )),
                                ]),
                                // Profile picture

                                const Positioned(
                                  child: Center(
                                    child: Text(
                                      "Your Verba-match",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),

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
