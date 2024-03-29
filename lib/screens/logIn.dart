// Import required packages
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/widgets/my_button_with_image.dart';
import 'package:verbatim_frontend/widgets/my_textfield.dart';
import 'package:verbatim_frontend/screens/signupErrorMessage.dart';
import '../widgets/my_button_no_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/gameObject.dart';
import 'package:verbatim_frontend/statsGameObject.dart';
import 'package:google_fonts/google_fonts.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  Map<String, Text> validationErrors = {};
  final usernameEmailController = TextEditingController();
  final passwordController = TextEditingController();

// Function to implement the login functionality
  void logIn(
      BuildContext context, String usernameOrEmail, String password) async {
    // Save user's info to the database
    saveUsersInfo(usernameOrEmail, password);
  }

// Function to implement the login functionality for a guest user
  void logInGuest(
      BuildContext context, String usernameOrEmail, String password) async {
    final response = await http.post(
      Uri.parse(
          '${BackendService.getBackendUrl()}submitResponseAfterLoginOrRegister'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'responseQ1': responseQ1,
        'responseQ2': responseQ2,
        'responseQ3': responseQ3,
        'responseQ4': responseQ4,
        'responseQ5': responseQ5,
        'isLogin': true,
        'emailOrUsername': usernameOrEmail,
        'password': password,
        'username': usernameOrEmail,
        'firstName': '',
        'lastName': '',
        'email': '',
        'withReferral': referer != '',
        'referringUsername': referer,
      }),
    );

    if (response.statusCode == 200) {
      //save user SharedPrefs
      final Map<String, dynamic>? data = json.decode(response.body);
      setState(() {
        responded = true;
        isGuest = true;
      });

      question1 = data!['q1'];
      question2 = data['q2'];
      question3 = data['q3'];
      question4 = data['q4'];
      question5 = data['q5'];

      id = data['globalChallengeId'];
      totalResponses = data['totalResponses'];

      categoryQ1 = data['categoryQ1'];
      categoryQ2 = data['categoryQ2'];
      categoryQ3 = data['categoryQ3'];
      categoryQ4 = data['categoryQ4'];
      categoryQ5 = data['categoryQ5'];

      if (responded) {
        numVerbatimQ1 = data['numVerbatimQ1'];
        numVerbatimQ2 = data['numVerbatimQ2'];
        numVerbatimQ3 = data['numVerbatimQ3'];
        numVerbatimQ4 = data['numVerbatimQ4'];
        numVerbatimQ5 = data['numVerbatimQ5'];

        statsQ1 = data['statsQ1'];
        statsQ2 = data['statsQ2'];
        statsQ3 = data['statsQ3'];
        statsQ4 = data['statsQ4'];
        statsQ5 = data['statsQ5'];

        totalResponses = data['totalResponses'];
        responded = true;

        verbatasticUsers = (data["verbatasticUsers"] as Map<String, dynamic>?)
                ?.map((key, value) {
              return MapEntry(key, (value as List).cast<String>());
            }) ??
            {};
        if (verbatasticUsers.isNotEmpty) {
          final MapEntry<String, List<String>?> firstEntry =
              verbatasticUsers.entries.first;

          verbatimedWord = firstEntry.key;
          verbatasticUsernames = firstEntry.value;
        } else {
          print("verbatasticUsers is empty");
        }
      }
      saveUsersInfo(usernameOrEmail, password);
    } else {
      logIn(context, usernameOrEmail, password);
    }
  }

  // Function to save user's info to the database
  void saveUsersInfo(String usernameOrEmail, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${BackendService.getBackendUrl()}login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'emailOrUsername': usernameOrEmail.toLowerCase(),
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData != null) {
          window.sessionStorage['UserName'] = responseData['username'];
          window.sessionStorage['LastName'] = responseData['lastName'];
          window.sessionStorage['FirstName'] = responseData['firstName'];
          window.sessionStorage['FullName'] =
              '${responseData['firstName']} ${responseData['lastName']}';
          window.sessionStorage['Bio'] = responseData['bio'] ?? "";
          window.sessionStorage['Email'] = responseData['email'];
          window.sessionStorage['Password'] = responseData['password'];
          window.sessionStorage['ProfileUrl'] =
              responseData['profilePicture'] ?? 'assets/profile_pic.png';
          Navigator.pushNamed(context, '/global_challenge');
        }
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                const SignupErrorMessage(pageName: 'log in')));
      }
    } catch (e) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SignupErrorMessage(pageName: 'log in'),
      ));
    }
  }

// Function to get the first and last name of a user given their full name
  Map<String, String> getFirstAndLastName(String fullName) {
    // Split the full name by whitespace
    List<String> nameParts = fullName.trim().split(' ');

    // Extract the first name and last name
    String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    String lastName = nameParts.length > 1 ? nameParts.last : '';

    // Return the first name and last name as a map
    return {'firstName': firstName, 'lastName': lastName};
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
      clientId:
          '1052195157201-9d7dskf4jihdd8b3ad6bmidnkoilu9ht.apps.googleusercontent.com');

  // Function to sign up with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      try {
        if (account != null) {
          logIn(context, account.email, " ");
        }
      } catch (e) {
        debugPrint('error on web signin with Google: $e');
        rethrow;
      }
    }
  }

// Validate a user's email
  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zAZ0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return emailRegex.hasMatch(email);
  }

// Show the appropriate error message during login
  void setValidationError(String field, String message) {
    setState(() {
      validationErrors[field] = Text(
        message,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
      );
    });
  }

// Update the error message appropriately
  void validateField(String value, String fieldName, String errorMessage) {
    if (value.isEmpty) {
      setValidationError(fieldName, errorMessage);
    }
  }

// Check if there is any error during login
  void validateUserInfo(BuildContext context, String email, String password) {
    // Clear any previous validation errors
    setState(() {
      validationErrors.clear();
    });

    validateField(email, "email", "Email is required");
    validateField(password, "password", "Password is required");

    // All validations passed; proceed with login

    if (validationErrors.isEmpty && responseQ1 == '') {
      //user not played
      print("Logging in guest, does not work with globals");
      logIn(context, email, password);
    }
    //in case theres data to carry over
    else if (responseQ1 != '') {
      logInGuest(context, email, password);
    }
  }

// Show the error message if any
  Widget? getValidationErrorWidget(String field) {
    return validationErrors.containsKey(field) ? validationErrors[field] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3EE),
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
                      'assets/Logo.png',
                      width: 200,
                      height: 160,
                    ),
                  ),
                ),
                SizedBox(height: 195.v),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 29),
                      MyTextField(
                        controller: usernameEmailController,
                        hintText: 'Email or Username',
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
                        child:
                            getValidationErrorWidget('password') ?? Container(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Forgot password?',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF3C64B1),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to the Forgot password page
                              Navigator.pushNamed(context, '/forgot_password');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      MyButtonNoImage(
                        buttonText: 'Sign-in',
                        onTap: () {
                          validateUserInfo(
                            context,
                            usernameEmailController.text,
                            passwordController.text,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      MyButtonWithImage(
                        buttonText: 'Sign in with Google',
                        hasButtonImage: true,
                        onTap: () {
                          signInWithGoogle(context);
                        },
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: 'Register',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Color(0xFF3C64B1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to the sign-up page
                                    Navigator.pushNamed(context, '/signup');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
