import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/widgets/button_settings.dart';
import 'package:verbatim_frontend/widgets/customAppBar_Settings.dart';
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
      //need a reset password endpoint
      Uri.parse(BackendService.getBackendUrl() + 'resetPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': SharedPrefs().getUserName(),
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );
    // do something to verify the response,
    if (response.statusCode == 200) {
      // get the account info to display as dummy text
      SharedPrefs().setPassword(newPassword);
    }
  } catch (error) {
    print('Sorry, cannot edit account settings: $error');
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  Map<String, Text> validationErrors = {};

  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

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

  void reset(
      BuildContext context, String newPassword, String oldPassword) async {
    try {
      final response = await http.post(
        //need a reset password endpoint
        Uri.parse(BackendService.getBackendUrl() + 'resetPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': SharedPrefs().getUserName(),
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );
      // do something to verify the response,
      if (response.statusCode == 200) {
        // get the account info to display as dummy text
        SharedPrefs().setPassword(newPassword);
        _showSuccessDialog(context);
      }
    } catch (error) {
      print('Sorry, cannot edit account settings: $error');
    }
  }

  bool isValid(
      String oldPassword, String newPassword, String confirmedPassword) {
    if (oldPassword == newPassword) {
      setValidationError("passwordResetError",
          "New passwords can not be the same as new passowrd");
      return false;
    }

    if (newPassword.isNotEmpty && newPassword != confirmedPassword) {
      setValidationError("passwordMismatch", "Passwords do not match.");
      return false;
    }
    if (SharedPrefs().getPassword() != oldPassword) {
      setValidationError(
          "incorrectPassword", "Incorrect value for currrent password");
      return false;
    }
    return true;
  }

  void setValidationError(String field, String message) {
    setState(() {
      validationErrors[field] = Text(
        message,
        style: TextStyle(color: Colors.red),
      );
    });
  }

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
                            CustomAppBarSettings(
                              title: 'Reset Password',
                            ),
                          ],
                        ),
                      ),
                      // field form boxes
                      SizedBox(height: 42),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Current password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 0.04,
                              letterSpacing: 0.30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      MyTextField(
                        controller: oldPassword,
                        hintText: 'current password',
                        obscureText: true,
                      ),
                      SizedBox(height: 42),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'New password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 0.04,
                              letterSpacing: 0.30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      MyTextField(
                        controller: newPassword,
                        hintText: 'new password',
                        obscureText: true,
                      ),
                      SizedBox(height: 42),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Confirm password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 0.04,
                              letterSpacing: 0.30,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      MyTextField(
                        controller: confirmPassword,
                        hintText: 'confirm password',
                        obscureText: true,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: [
                            SizedBox(height: 42),
                            Padding(
                              padding: EdgeInsets.only(left: 1.5),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: DeepOrangeButton(
                                  buttonText: 'Reset Password',
                                  onPressed: () {
                                    reset(
                                      context,
                                      oldPassword.text,
                                      newPassword.text,
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
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
    );
  }

  // validate that the new password is not the old password
  // passwords match and they meet minimum requirements
}
