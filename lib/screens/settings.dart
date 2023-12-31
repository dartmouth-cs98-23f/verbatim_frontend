import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/screens/globalChallenge.dart';
import 'package:verbatim_frontend/widgets/my_button_no_image.dart';
import 'package:verbatim_frontend/widgets/my_textfield.dart';
import 'sideBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/custom_tab.dart';
import 'dart:async';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/resetPassword.dart';
import 'package:verbatim_frontend/widgets/testCustomBar.dart';

//get the edits to send back as an acoount settings thing
//getsignin -> look for input function to replace

//cant find old username
//if changed username, username is taken by someone else
//

void edits(
  BuildContext context,
  String firstName,
  String lastName,
  String username,
  String newUsername,
  String bio,
  String email,
  String profilePic,
) async {
  try {
    final response = await http.post(
      Uri.parse(BackendService.getBackendUrl() + 'accountSettings'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'newUsername': newUsername,
        'email': email,
        'bio': bio,
        'profilePic': profilePic,
      }),
    );
    //do sth to verify the response,
    if (response.statusCode == 200) {
      //get the account info to display as dummy text
      SharedPrefs().setFirstName(firstName);
      SharedPrefs().setLastName(lastName);
      SharedPrefs().setBio(bio);
      SharedPrefs().setEmail(email);
      SharedPrefs().setUserName(newUsername);
      _showSuccessDialog(context);
    }
  } catch (error) {
    print('Sorry cannot edit account settings:$error');
  }
}

String getVal(String? fieldval, String currentval) {
  String finalVal;
  fieldval!.isEmpty ? finalVal = currentval : finalVal = fieldval;
  return finalVal;
}

void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Set the corner radius
        ),
        backgroundColor:
            Color.fromARGB(255, 255, 243, 238), // Set the background color
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Verba',
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '-tastic!',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        content: Text(
          'Your changes have been recorded!',
          style: TextStyle(color: Colors.black), // Set text color
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'OK',
              style: TextStyle(color: Colors.blue), // Set button text color
            ),
          ),
        ],
      );
    },
  );
}

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _SettingsState();
}

class _SettingsState extends State<settings> {
  final firstNameSettings = TextEditingController();
  final lastNameSettings = TextEditingController();

  final usernameSettings = TextEditingController();
  final bioSettings = TextEditingController();
  final emailSettings = TextEditingController();
  final String assetName = 'assets/img1.svg';
  final String profile = 'assets/profile_pic.png';

  @override
  Widget build(BuildContext context) {
// TODO: implement build
//SingleChildScrollView(
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
                            // orange background
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

                            // app bar on top of background
                            CustomAppBar(),
                            //testCustomBar(),

                            // 'Account Settings #'
                            const Positioned(
                              child: Center(
                                child: Text(
                                  'Account Settings',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 0,
                              left: 30,
                              child: Stack(
                                children: [
                                  Container(
                                    child: Align(
                                      alignment: Alignment
                                          .centerLeft, // Align the image to the left
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 0, top: 0),
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255,
                                                  255,
                                                  243,
                                                  238), // Color of the border
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            child: ClipOval(
                                              child: Image.asset(
                                                profile,
                                                width: 5,
                                                height: 5,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  //doesnt work because it goes beyond the profile dimensions
                                  Positioned(
                                    bottom: 25,
                                    left: 100,
                                    child: Container(
                                      child: Padding(
                                          padding:
                                              EdgeInsets.only(top: 0, left: 0),
                                          child: SvgPicture.asset(
                                            'assets/editIcon.svg',
                                            width: 24,
                                            height: 24,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //Reset password
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: RichText(
                          text: TextSpan(
                        text: 'Reset password',
                        style: const TextStyle(
                          color: Color(0xFF3C64B1),
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to the sign-in page
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ));
                          },
                      ))),
                ),

                const SizedBox(height: 42),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'First Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        height: 0.04,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                MyTextField(
                    controller: firstNameSettings,
                    hintText: SharedPrefs().getFirstName() ?? "",
                    obscureText: false),

                //last name
                const SizedBox(height: 42),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Last Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        height: 0.04,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                MyTextField(
                    controller: lastNameSettings,
                    hintText: SharedPrefs().getLastName() ?? "",
                    obscureText: false),

                //username
                const SizedBox(height: 42),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Username',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        height: 0.04,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyTextField(
                    controller: usernameSettings,
                    hintText: SharedPrefs().getUserName() ?? "",
                    obscureText: false),

                //bio
                const SizedBox(height: 42),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bio',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        height: 0.04,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyTextField(
                    controller: bioSettings,
                    hintText: SharedPrefs().getBio() ?? "",
                    obscureText: false),

                //email
                //bio
                const SizedBox(height: 42),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        height: 0.04,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MyTextField(
                    controller: emailSettings,
                    hintText: SharedPrefs().getEmail() ?? "",
                    obscureText: false),

                Center(
                    child: Column(
                  children: [
                    const SizedBox(height: 30),
                    MyButtonNoImage(
                        buttonText: "Submit Changes",
                        onTap: () {
                          edits(
                            context,
                            getVal(firstNameSettings.text,
                                SharedPrefs().getFirstName() ?? ""),
                            getVal(lastNameSettings.text,
                                SharedPrefs().getLastName() ?? ""),
                            SharedPrefs().getUserName() ?? "",
                            getVal(usernameSettings.text,
                                SharedPrefs().getUserName() ?? ""),
                            getVal(
                                bioSettings.text, SharedPrefs().getBio() ?? ""),
                            getVal(emailSettings.text,
                                SharedPrefs().getEmail() ?? ""),
                            profile,
                          );
                        })
                  ],
                ))
              ],
            )),
      )),
    ));

    // );
  }
}
