import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/widgets/my_textfield.dart';
import 'package:verbatim_frontend/screens/signupErrorMessage.dart';
import '../Components/shared_prefs.dart';
import '../widgets/my_button_no_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/size.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  Map<String, Text> validationErrors = {};
  final usernameEmailController = TextEditingController();
  final passwordController = TextEditingController();
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ['email'],
  //   clientId:
  //       '297398575103-o3engamrir3bf4pupurvj8lm4mn0iuqt.apps.googleusercontent.com',
  // );

  void logIn(
      BuildContext context, String usernameOrEmail, String password) async {
    // Save user's info to the database
    saveUsersInfo(usernameOrEmail, password);
  }

  void logInGuest(
      BuildContext context, String usernameOrEmail, String password) async {
    final response = await http.post(
      Uri.parse(
          '${BackendService.getBackendUrl()}submitResponseAfterLoginOrRegister'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'responseQ1': SharedPrefs().getResponse1(),
        'responseQ2': SharedPrefs().getResponse2(),
        'responseQ3': SharedPrefs().getResponse3(),
        'responseQ4': SharedPrefs().getResponse4(),
        'responseQ5': SharedPrefs().getResponse5(),
        'isLogin': true,
        'emailOrUsername': usernameOrEmail,
        'password': password,
        'username': '',
        'firstName': '',
        'lastName': '',
        'email': '',
        'withReferral': SharedPrefs().getReferer() != '',
        'referringUsername': SharedPrefs().getReferer(),
      }),
    );

    if (response.statusCode == 200) {
      //save user SharedPrefs
      final responseData = json.decode(response.body);
      SharedPrefs().setEmail(responseData['email']);
      SharedPrefs().setUserName(responseData['username']);
      SharedPrefs().setPassword(responseData['password']);
      SharedPrefs().setFirstName(responseData['firstName'] ?? '');
      SharedPrefs().setLastName(responseData['lastName'] ?? '');
      SharedPrefs().setBio(responseData['bio'] ?? '');
      // SharedPrefs().setBio(responseData['profilePicture']);
      Navigator.pushNamed(context, '/global_challenge');
      print('Log-in successful');
      print("Yaaaay lets go");
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
          // Authentication successful: Save the user info to the disk so that they can persist to other pages
          SharedPrefs().setEmail(responseData['email']);
          SharedPrefs().setUserName(responseData['username']);
          SharedPrefs().setPassword(responseData['password']);
          SharedPrefs().setFirstName(responseData['firstName'] ?? '');
          SharedPrefs().setLastName(responseData['lastName'] ?? '');
          SharedPrefs().setBio(responseData['bio'] ?? '');
          SharedPrefs().setProfileUrl(
              responseData['profilePicture'] ?? 'assets/profile_pic.png');

          Navigator.pushNamed(context, '/global_challenge');
        }
      } else {
        print('Error during log-in: ${response.statusCode.toString()}');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                const SignupErrorMessage(pageName: 'log in')));
      }
    } catch (e) {
      print('Error during sign-up: $e');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SignupErrorMessage(pageName: 'log in'),
      ));
    }
  }

  // Sign in with Google functionality
  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? account = await _googleSignIn.signIn();

  //     if (account != null) {
  //       saveUsersInfo(account.email, 'unavailable');
  //     }
  //   } catch (error) {
  //     // Handle any errors that occur during the Google Sign-In process.
  //     print('Error during Google Sign-In: $error');
  //   }
  // }

  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zAZ0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return emailRegex.hasMatch(email);
  }

  void setValidationError(String field, String message) {
    setState(() {
      validationErrors[field] = Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontFamily: 'Poppins',
        ),
      );
    });
  }

  void validateField(String value, String fieldName, String errorMessage) {
    if (value.isEmpty) {
      setValidationError(fieldName, errorMessage);
    }
  }

  void validateUserInfo(BuildContext context, String email, String password) {
    // Clear any previous validation errors
    setState(() {
      validationErrors.clear();
    });

    validateField(email, "email", "Email is required");
    validateField(password, "password", "Password is required");

    // All validations passed; proceed with login

    if (validationErrors.isEmpty && SharedPrefs().getResponse1() == '') {
      //user not played
      logIn(context, email, password);
    } else if (SharedPrefs().getResponse1() != '') {
      //logIn(context, email, password);
      logIn(context, email, password);
      // logInGuest(context, email, password);
    }
  }

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
                          style: const TextStyle(
                            color: Color(0xFF3C64B1),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
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

                      //taking this out for now
                      /*
                      const SizedBox(height: 20),
                      MyButtonWithImage(
                        buttonText: 'Sign in with Google',
                        hasButtonImage: true,
                        onTap: () {
                          // signInWithGoogle();
                        },
                      ),
                      */
                      const SizedBox(height: 10),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text: 'Register',
                                style: const TextStyle(
                                  color: Color(0xFF3C64B1),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
// Blue color for the link
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
