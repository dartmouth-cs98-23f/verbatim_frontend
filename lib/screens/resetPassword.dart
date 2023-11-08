import 'package:flutter/widgets.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

void reset(BuildContext context, String newPassword, String oldPassword) async {
  try {
    final response = await http.post(
      //need a rest password endpoint
      Uri.parse('http://localhost:8080/api/v1/resetPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': SharedPrefs().getUserName(),
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );
    //do sth to verify the response,
    if (response.statusCode == 200) {
      //get the account info to display as dummy text
      SharedPrefs().setPassword(newPassword);
    }
  } catch (error) {
    print('Sorry cannot edit account settings:$error');
  }
}

class resetPassword extends StatefulWidget {
  const resetPassword({super.key});

  @override
  State<resetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<resetPassword> {
  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/img1.svg';
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 255, 243, 238),
      body: SingleChildScrollView(
          child: Container(
              color: Color.fromARGB(255, 255, 243, 238),
              child: Column(
                children: [
                  SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 260.v,
                            width: double.maxFinite,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
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
                                CustomAppBar(),
                                const Positioned(
                                    child: Center(
                                  child: Text(
                                    'Reset Password',
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          //field form boxes
                          SizedBox(height: 30),
                          const Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Old password',
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
                              controller: oldPassword,
                              hintText: 'current password',
                              obscureText: true),

                          const SizedBox(height: 30),
                          const Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'New password',
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
                              controller: newPassword,
                              hintText: 'new password',
                              obscureText: true),

                          const SizedBox(height: 30),
                          const Padding(
                            padding: EdgeInsets.only(left: 30.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Confirm password',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.w700,
                                  height: 0.04,
                                  letterSpacing: 0.30,
                                ),

                                const SizedBox(height: 20),
                                MyTextField(
                                    controller: confirmPassword,
                                    hintText: 'confirm password',
                                    obscureText: true),

                                Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        MyButtonNoImage(
                                            buttonText: "Submit",
                                            onTap: () {
                                              reset(
                                                context,
                                                oldPassword.text,
                                                newPassword.text
                                              );
                                        })
                                      ],
                                    ))
                        ],
                      ))
                ],
              ))),
    ));
  }

  //validate that new password is not old password
  //passwords match and they meet minimum requirements
}

