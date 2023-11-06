import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:verbatim_frontend/widgets/my_textfield.dart';
import 'package:verbatim_frontend/screens/forgotPassword.dart';
import 'package:verbatim_frontend/screens/signUp.dart';
import 'package:verbatim_frontend/screens/signupErrorMessage.dart';
import '../Components/shared_prefs.dart';
import '../widgets/my_button_with_image.dart';
import '../widgets/my_button_no_image.dart';
import 'globalChallenge.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  Map<String, Text> validationErrors = {};
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId: '297398575103-o3engamrir3bf4pupurvj8lm4mn0iuqt.apps.googleusercontent.com',
  );

  void logIn(BuildContext context, String email, String password) async {
    try {
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
          String userEmail = responseData['email'];
          String userPassword = responseData['password'];

          // Save the user info to the disk so that they can persist to other pages
          SharedPrefs().setEmail(userEmail);
          SharedPrefs().setUserName(username);
          SharedPrefs().setPassword(userPassword);

          print("\nThe email is : $userEmail \n The password is : $userPassword");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => globalChallenge(),
            ),
          );
          print('Log-in successful');
        }
      } else {
        print('Error during sign-up: ${response.statusCode.toString()}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupErrorMessage(pageName: 'log in'),
          ),
        );
      }
    } catch (e) {
      print('Error during sign-up: $e');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupErrorMessage(pageName: 'log in'),
        ),
      );
    }
  }

  // Sign in with Google functionality
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
          body: jsonEncode({'emailOrUsername': account.email, 'password': ''}),
        );

        if (response.statusCode == 200) {
          // Navigate to the global challenge page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => globalChallenge(),
            ),
          );
        } else {
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
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zAZ0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return emailRegex.hasMatch(email);
  }

  void setValidationError(String field, String message) {
    setState(() {
      validationErrors[field] = Text(
        message,
        style: TextStyle(color: Colors.red),
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
    if (validationErrors.isEmpty) {
      logIn(context, email, password);
    }
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
                  padding: const EdgeInsets.only(
                      left: 220.0), // Adjust the padding as needed
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
                              ));
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0), // Adjust the left padding as needed
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
                      MyButtonWithImage(
                        buttonText: 'Sign in with Google',
                        hasButtonImage: true,
                        onTap: () {
                          signInWithGoogle();
                        },
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0), // Adjust the padding as needed
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: 'Register',
                                style: TextStyle(
                                  color: Color(0xFF3C64B1),
                                  fontWeight: FontWeight.w700, // Blue color for the link
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to the sign-up page
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ));
                                  },
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
    );
  }
}
