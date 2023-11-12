import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/widgets/my_textfield.dart';
import 'package:verbatim_frontend/screens/logIn.dart';
import 'package:verbatim_frontend/screens/signupErrorMessage.dart';
import '../widgets/my_button_no_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  Map<String, Text> validationErrors = {};

  void resetPassword(BuildContext context, String email) async {
    try {
      validateField(email, "email", "Email is required");
      final response = await http.post(
        Uri.parse('https://verbatim-backend-ad94f6ae4b2e.herokuapp.com/api/v1/resetPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData != null) {
          // Authentication successful
          String username = responseData['username'];
          String email = responseData['email'];
          String password = responseData['password'];

          print("\nThe email is : ${email}");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LogIn(),
            ),
          );
          print('Reset password successful');
        }
      }
      else {
        print('Error during reset password: ${response.statusCode.toString()}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupErrorMessage(pageName: 'log in'),
          ),
        );
      }
    }
    catch (e) {
      print('Error during reset password: ${e.toString()}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupErrorMessage(pageName: 'log in'),
        ),
      );
    }
  }

  // Validate user's email
  void validateUserInfo(BuildContext context, String email) {
    // Clear any previous validation errors
    setState(() {
      validationErrors.clear();
    });
    print('email in reset: ${email}');

    validateField(email, "email", "Email is required");
    // Validate email
    if (email.isNotEmpty && !EmailValidator.validate(email)) {
      setValidationError("email", "The email format is invalid. Verify again.");
    }

    // Validate there are no errors at all, then proceed with resetting the password
    if (validationErrors.isEmpty) {
      resetPassword(context, email);
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

                const SizedBox(height: 180),
                Center(
                  child: Text(
                    'Set a New Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE76F51),
                      fontSize: 32,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0.30,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'To set a new password, please enter your email address below. You will receive an email with instructions on how to set a new password.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ],
                  ),
                ),

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
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                MyButtonNoImage(
                  buttonText: 'Reset Password',
                  onTap: () {
                    validateUserInfo(context, emailController.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}