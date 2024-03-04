import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/screens/signupErrorMessage.dart';
import 'package:verbatim_frontend/widgets/check_unique_username_dialog.dart';
import 'package:verbatim_frontend/widgets/errorDialog.dart';
import 'package:http/http.dart' as http;

class SignUpWithGoogle {
  List<String> userUsernames = [];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
      clientId:
          '1052195157201-9d7dskf4jihdd8b3ad6bmidnkoilu9ht.apps.googleusercontent.com');

  // Function to sign up with Google
  Future<void> signUpWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      try {
        if (account != null) {
          print("\nSigning with google: \n");
          print("\nEmail: ${account.email}\n");
          print("\nName: ${account.displayName} \n");

          Map<String, String> nameMap =
              getFirstAndLastName(account.displayName as String);

          String firstName = nameMap['firstName'] ?? '';
          String lastName = nameMap['lastName'] ?? '';

          print("\n firstName: $firstName\n");
          print("\n lastName: $lastName \n");

          // Show dialog to get unique username
          String? username = await _getUniqueUsername(context);

          // Check if username is not null or empty
          if (username != null && username.isNotEmpty) {
            // Call saveUsersInfo with provided username
            saveUsersInfo(context, firstName, lastName, username, account.email,
                " ", " ");
          } else {
            print("\nUsername is null or empty.\n");
          }
        } else {
          print('\nThe google account is not found.');
        }
      } catch (e) {
        debugPrint('error on web signin: $e');
        rethrow;
      }
    }
  }

  Map<String, String> getFirstAndLastName(String fullName) {
    // Split the full name by whitespace
    List<String> nameParts = fullName.trim().split(' ');

    // Extract the first name and last name
    String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    String lastName = nameParts.length > 1 ? nameParts.last : '';

    // Return the first name and last name as a map
    return {'firstName': firstName, 'lastName': lastName};
  }

  Future<String?> _getUniqueUsername(BuildContext context) async {
    TextEditingController usernameController = TextEditingController();
    String? uniqueUsername;
    CheckUsernameDialog dialog = CheckUsernameDialog();

    do {
      uniqueUsername = await dialog.show(context, usernameController);
    } while (uniqueUsername == null);

    return uniqueUsername;
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
}
