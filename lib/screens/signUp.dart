import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/Components/my_textfield.dart';
import '../Components/my_button.dart';
import 'globalChallenge.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String _backendResponse = "";
  Map<String, Text> validationErrors = {};
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp(BuildContext context, username, String email, String password, String confirmPassword) async {

    try{
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/v1/register'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'username': username, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Successful sign-up
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  globalChallenge()), // Use your actual page widget
        );
        print('Sign-up successful');
      }
      else{
        print('Error during sign-up: ${response.statusCode.toString()}');
      }
    }
    catch(e){
      print('Error during sign-up: ${e.toString()}');
    }
  }

  // To be implemented later
  void signUpWithGoogle(){
    print('Signing up with Google to be done later!');
  }

  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return emailRegex.hasMatch(email);
  }

  void placeHolder(BuildContext context, String username, String email, String password, String confirmedPassword) {
    // Clear any previous validation errors
    setState(() {
      validationErrors.clear();
    });

    validateField(username, "username", "Username is required");
    validateField(email, "email", "Email is required");
    validateField(password, "password", "Password is required");
    validateField(confirmedPassword, "confirmedPassword", "Confirm your password");

    // Check for specific validation rules
    if (username.isNotEmpty) {
      if (username.contains('@')) {
        setValidationError("username", "Username should not contain the '@' character");
      }
    }

    if (email.isNotEmpty && !isValidEmail(email)) {
      setValidationError("email", "The email you provided is invalid. Verify again.");
    }

    if (password.isNotEmpty) {
      if (password.length < 8) {
        setValidationError("password", "Your password should be at least 8 characters long.");
      }
    }

    if (password.isNotEmpty && password != confirmedPassword) {
      setValidationError("passwordMismatch", "Passwords do not match.");
    }

    if (validationErrors.isEmpty) {
      // Continue with sign-up
      print('Successfully signed up with this info: $username, $email, $password, $confirmedPassword');
      signUp(context, username, email, password, confirmedPassword);
    }
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

                const SizedBox(height: 120),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create an account',
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
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 29),
                      MyTextField(
                        controller: usernameController,
                        hintText: 'Username',
                        obscureText: false,
                      ),
                      Container(
                        child: getValidationErrorWidget('username') ?? Container(),
                      ),

                      const SizedBox(height: 25),
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

                      const SizedBox(height: 25),
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),
                      Container(
                        child: getValidationErrorWidget('passwordMismatch') ?? Container(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0), // Adjust the left padding as needed
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 35),
                        MyButton(
                          buttonText: 'Create account',
                          hasButtonImage: false,
                          onTap: () {
                            placeHolder(
                              context,
                              usernameController.text,
                              emailController.text,
                              passwordController.text,
                              confirmPasswordController.text,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                          buttonText: 'Sign up with Google',
                          hasButtonImage: true,
                          onTap: () {
                            signUpWithGoogle();
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