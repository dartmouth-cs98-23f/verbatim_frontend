import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbatim_frontend/widgets/my_textfield.dart';
import 'package:verbatim_frontend/screens/forgotPassword.dart';
import 'package:verbatim_frontend/screens/signUp.dart';
import 'package:verbatim_frontend/screens/signupErrorMessage.dart';
import '../Components/shared_prefs.dart';
import '../widgets/my_button_with_image.dart';
import '../widgets/my_button_no_image.dart';
import 'draft.dart';
import 'globalChallenge.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';


class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late String _backendResponse = "";
  Map<String, Text> validationErrors = {};
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'], clientId: '297398575103-o3engamrir3bf4pupurvj8lm4mn0iuqt.apps.googleusercontent.com');

  void logIn(BuildContext context, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final response = await http.post(
        Uri.parse('http://localhost:8080/api/v1/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'emailOrUsername': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData != null) {
          // Authentication successful
          String username = responseData['username'];
          String email = responseData['email'];
          String password = responseData['password'];

          // Save the user info to the disk so that they can persist to other pages
          SharedPrefs().setEmail(email);
          SharedPrefs().setUserName(username);
          SharedPrefs().setPassword(password);

          print("\nThe email is : ${email} \n The password is : ${password}");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  globalChallenge(
                    username: username,
                    email: email,
                    password: password,
                  ),
            ),
          );

          print('Log-in successful');
        }
      }
      else {
        print('Error during sign-up: ${response.statusCode.toString()}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupErrorMessage(),
          ),
        );
      }
    }
    catch (e) {
    print('Error during sign-up: ${e.toString()}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupErrorMessage(),
      ),
    );
  }
}

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        // User sign-in is successful
        print('Google Sign-In successful');
        print('Sign up with Google: ${account.email}');

        final response = await http.post(
          Uri.parse('http://localhost:8080/api/v1/register'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },

          body: jsonEncode({
            'emailOrUsername': account.email,
            'password': ''
          }),
        );

        if (response.statusCode == 200) {
          // Navigate to the global challenge page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  globalChallenge(
                    username:
                    '',
                    // to be decided - give them suggestions of what to use as their username
                    email: account.email,
                    password: '',
                  ),
            ),
          );
        }
        else{
          print('Error during sign-up with Google: ${response.statusCode.toString()}');
        }
      } else {
        // User canceled the Google Sign-In process or encountered an error.
        print('Google Sign-In canceled or failed');
      }
    } catch (error) {
      // Handle any errors that occur during the Google Sign-In process.
      print('Error during Google Sign-In: $error');
    }
  }

  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return emailRegex.hasMatch(email);
  }

  void validateUserInfo(BuildContext context, String email, String password) {
    // Clear any previous validation errors
    setState(() {
      validationErrors.clear();
    });
    print('email is: ${email}');
    print('password is: ${password}');

    validateField(email, "email", "Email is required");
    validateField(password, "password", "Password is required");

    print('here');
    // All validations passed; proceed with login
    logIn(context, email, password);
    print('after');
  }

  void validateField(String value, String fieldName, String errorMessage) {
    if (value.isEmpty) {
      setValidationError(fieldName, errorMessage);
    }
  }

  void setValidationError(String field, String message) {
    setState(() {
      validationErrors[field] = Text(
        message,
        style: TextStyle(color: Colors.red),
      );
    });
  }

  Widget? getValidationErrorWidget(String field) {
    return validationErrors.containsKey(field) ? validationErrors[field] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/Logo.png', // Replace with the path to your image asset
                      width: 150, // Set the width and height to your preference
                      height: 120,
                    ),
                  ),
                ),

                const SizedBox(height: 195),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 29),
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      Container(
                        child: getValidationErrorWidget('email') ?? Container(),
                      ),

                      const SizedBox(height: 25),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      Container(
                        child: getValidationErrorWidget('password') ?? Container(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 220.0), // Adjust the padding as needed
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Forgot password?',
                          style: TextStyle(
                            color: Color(0xFF3C64B1),
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to the sign-in page
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ForgotPassword(),  // This will be a forgot password page routing
                              )
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0), // Adjust the left padding as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      MyButtonNoImage(
                        buttonText: 'Sign-in',
                        onTap: () {
                          validateUserInfo(
                            context,
                            emailController.text,
                            passwordController.text,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        buttonText: 'Sign in with Google',
                        hasButtonImage: true,
                        onTap: () {
                          signInWithGoogle();
                        },
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
}