import 'dart:html';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/widgets/errorDialog.dart';
import 'package:verbatim_frontend/widgets/my_button_no_image.dart';
import 'package:verbatim_frontend/widgets/my_button_with_image.dart';
import 'package:verbatim_frontend/widgets/my_textfield.dart';
import 'package:verbatim_frontend/screens/signupErrorMessage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:verbatim_frontend/widgets/showSuccessDialog.dart';
import 'package:verbatim_frontend/widgets/signUpWithGoogle.dart';

class SignUp extends StatefulWidget {
  //TODO: figure out how to not need the
  const SignUp({
    super.key,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Map<String, Text> validationErrors = {};
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp(BuildContext context, String firstName, String lastName,
      String username, String email, String password, String confirmPassword) {
    saveUsersInfo(context, firstName, lastName, username, email, password,
        confirmPassword);
  }

  // Function to save user's info to the database
  void saveUsersInfo(
      BuildContext context,
      String firstName,
      String lastName,
      String username,
      String email,
      String password,
      String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${BackendService.getBackendUrl()}register'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        window.sessionStorage['UserName'] = username;
        window.sessionStorage['FirstName'] = firstName;
        window.sessionStorage['LastName'] = lastName;
        window.sessionStorage['FullName'] = '$firstName $lastName';
        window.sessionStorage['Bio'] = "";
        window.sessionStorage['Email'] = email;
        window.sessionStorage['Password'] = password;
        window.sessionStorage['ProfileUrl'] = 'assets/profile_pic.png';

        // Successful sign-up: Navigate to the 'OnBoardingPage1' page
        Navigator.pushNamed(context, '/onboarding_page1');
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SignupErrorMessage(pageName: 'sign up'),
        ));
      }
    } catch (e) {
      print('Error during sign-up: ${e.toString()}');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SignupErrorMessage(pageName: 'sign up'),
      ));
    }
  }

  // // Function to sign up with Google
  // Future<void> signUpWithGoogle() async {
  //   if (kIsWeb) {
  //     final GoogleSignInAccount? account = await _googleSignIn.signIn();
  //     try {
  //       if (account != null) {
  //         print("\nSigning with google: \n");
  //         print("\nEmail: ${account.email}\n");
  //         print("\nName: ${account.displayName} \n");

  //         Map<String, String> nameMap =
  //             getFirstAndLastName(account.displayName as String);

  //         String firstName = nameMap['firstName'] ?? '';
  //         String lastName = nameMap['lastName'] ?? '';

  //         print("\n firstName: $firstName\n");
  //         print("\n lastName: $lastName \n");

  //         saveUsersInfo(
  //             context, firstName, lastName, firstName, account.email, " ", " ");
  //       } else {
  //         print('\nThe google account is not found.');
  //       }
  //     } catch (e) {
  //       debugPrint('error on web signin: $e');
  //       rethrow;
  //     }
  //   }
  // }

  Map<String, String> getFirstAndLastName(String fullName) {
    // Split the full name by whitespace
    List<String> nameParts = fullName.trim().split(' ');

    // Extract the first name and last name
    String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    String lastName = nameParts.length > 1 ? nameParts.last : '';

    // Return the first name and last name as a map
    return {'firstName': firstName, 'lastName': lastName};
  }

  void validateUserInfo(
      BuildContext context,
      String firstName,
      String lastName,
      String username,
      String email,
      String password,
      String confirmedPassword) {
    // Clear any previous validation errors
    setState(() {
      validationErrors.clear();
    });

    validateField(firstName, "firstName", "First name is required");
    validateField(lastName, "lastName", "Last name is required");
    validateField(username, "username", "Username is required");
    validateField(email, "email", "Email is required");
    validateField(password, "password", "Password is required");
    validateField(
        confirmedPassword, "confirmedPassword", "Confirm your password");

    // Check for specific validation rules
    final firstLastNamesValidCharacters = RegExp(
        r"^[a-zA-Z\s\-'_]+$"); // regex for validating first and last names
    final usernameValidCharacters =
        RegExp(r'^[a-zA-Z0-9_]+$'); // regex for validating a username
    final passwordComplexity = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).+$'); // regex for validating a password

    if (firstName.isNotEmpty) {
      // Check for length
      if (firstName.isEmpty || firstName.length > 50) {
        setValidationError(
            "firstName", "First name should be between 1 and 50 characters");
      }
      // Check character set
      if (!firstLastNamesValidCharacters.hasMatch(firstName)) {
        setValidationError("firstName",
            "First name should only contain letters, spaces, hyphens, and apostrophes");
      }
    }

    if (lastName.isNotEmpty) {
      // Check for length
      if (lastName.length > 50) {
        setValidationError(
            "lastName", "Last name should be between 1 and 50 characters");
      }
      // Check character set
      if (!firstLastNamesValidCharacters.hasMatch(lastName)) {
        setValidationError("lastName",
            "Last name should only contain letters, spaces, hyphens, and apostrophes");
      }
    }

    if (username.isNotEmpty) {
      // Check for length
      if (username.length < 3 || username.length > 30) {
        setValidationError(
            "username", "Username should be between 3 and 30 characters");
      }
      // Check character set
      if (!usernameValidCharacters.hasMatch(username)) {
        setValidationError("username",
            "Username should only contain letters, numbers, and underscores");
      }
    }

    // Validate email
    if (email.isNotEmpty && !EmailValidator.validate(email)) {
      setValidationError("email", "The email format is invalid. Verify again.");
    }

    // Validate password
    if (password.isNotEmpty) {
      // Check password length and complexity (at least one uppercase letter, one lowercase letter, one number, and one special character)

      // if (!passwordComplexity.hasMatch(password) || password.length < 8) {
      //   setValidationError("password",
      //       "Your password should be at least 8 characters long and include an uppercase letter, a lowercase letter, a number, and one of the following special characters: !, @, #, \$, %, ^, &, *");
      // }

      if (password.length < 8) {
        setValidationError(
            "password", "Your password should be at least 8 characters long.");
      }

      // Check password matches with the confirmed password
      if (password.isNotEmpty && password != confirmedPassword) {
        setValidationError("passwordMismatch", "Passwords do not match.");
      }
    }

    // Validate there are no errors at all
    if (validationErrors.isEmpty) {
      // Continue with sign-up
      print(
          'Successfully signed up with this info: $firstName, $lastName, $username, $email, $password, $confirmedPassword');

      //if user hasnt played global challenge yer
      print("signup 1");

      signUp(context, firstName, lastName, username.toLowerCase(),
          email.toLowerCase(), password, confirmedPassword);
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
        style: GoogleFonts.poppins(
            textStyle: const TextStyle(
          color: Colors.red,
        )),
      );
    });
  }

  Widget? getValidationErrorWidget(String field) {
    return validationErrors.containsKey(field) ? validationErrors[field] : null;
  }

  @override
  Widget build(BuildContext context) {
    //TODO: homie use this
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
                      'assets/Logo.png', // Replace with the path to your image asset
                      width: 150, // Set the width and height to your preference
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create an account',
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 0.04,
                        letterSpacing: 0.30,
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: firstNameController,
                        hintText: 'First name',
                        obscureText: false,
                      ),
                      Container(
                        child: getValidationErrorWidget('firstName') ??
                            Container(),
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: lastNameController,
                        hintText: 'Last name',
                        obscureText: false,
                      ),
                      Container(
                        child:
                            getValidationErrorWidget('lastName') ?? Container(),
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: usernameController,
                        hintText: 'Username',
                        obscureText: false,
                      ),
                      Container(
                        child:
                            getValidationErrorWidget('username') ?? Container(),
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      Container(
                        child: getValidationErrorWidget('email') ?? Container(),
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      Container(
                        child:
                            getValidationErrorWidget('password') ?? Container(),
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),
                      Container(
                        child: getValidationErrorWidget('passwordMismatch') ??
                            Container(),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),
                      MyButtonNoImage(
                        buttonText: 'Create account',
                        onTap: () {
                          validateUserInfo(
                            context,
                            firstNameController.text,
                            lastNameController.text,
                            usernameController.text,
                            emailController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      MyButtonWithImage(
                        buttonText: "Sign up with Google",
                        hasButtonImage: true,
                        onTap: () {
                          SignUpWithGoogle signUpWithGoogle =
                              SignUpWithGoogle();

                          signUpWithGoogle.signUpWithGoogle(context);
                        },
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                )),
                              ),
                              TextSpan(
                                text: 'Sign in',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  color: Color(0xFF3C64B1),
                                  fontWeight: FontWeight.w800,
// Blue color for the link
                                )),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to the sign-in page
                                    Navigator.pushNamed(context, '/login');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
