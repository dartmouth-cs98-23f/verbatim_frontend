import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/Components/my_textfield.dart';
import '../Components/my_button.dart';
import 'draft.dart';
import 'globalChallenge.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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
          String email = responseData['email'];
          String password = responseData['password']; // You have the user's password, but you may not want to store it in the client.

          print("\nThe email is : ${email} \n The password is : ${password}");
          // // Navigate to the global challenge page.
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => globalChallenge(
          //       // email: email,
          //       // password: password,
          //     ),
          //   ),
          // );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => globalChallenge(
                email: email,
                password: password,
              ),
            ),
          );

          print('Log-in successful');
        } else {
          print('Authentication failed: Response data is null');
        }
      } else {
        print('Authentication failed: ${response.statusCode.toString()}');
      }
    } catch (e) {
      print('Error during authentication: ${e.toString()}');
    }
  }

  // To be implemented later
  void signInWithGoogle(){
    print('Signing up with Google to be done later!');
  }

  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return emailRegex.hasMatch(email);
  }

  void placeHolder(BuildContext context, String email, String password) {
    // Clear any previous validation errors
    setState(() {
      validationErrors.clear();
    });
    print('email is: ${email}');
    print('password is: ${password}');

    validateField(email, "email", "Email is required");
    validateField(password, "password", "Password is required");

    // Check for specific validation rules
    // if (email.isNotEmpty) {
    //   if (email.contains('@')) {
    //     // Treat it as an email else as a username
    //     print('Treat the entry as an email else as a username');
    //     return;
    //   }
    // }
    //
    // if (email.isNotEmpty && !isValidEmail(email)) {
    //   setValidationError("email", "The email you provided is invalid. Verify again.");
    //   return;
    // }

    if (password.isNotEmpty) {
      if (password.length < 8) {
        setValidationError("password", "Your password should be at least 8 characters long.");
        return;
      }
    }

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Verbatim',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 0.04,
                        letterSpacing: 0.10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 200),
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
                Padding(
                  padding: const EdgeInsets.only(left: 5.0), // Adjust the left padding as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      MyButton(
                        buttonText: 'Sign-in',
                        hasButtonImage: false,
                        onTap: () {
                          placeHolder(
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