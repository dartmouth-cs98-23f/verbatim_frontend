import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/gameObject.dart';
import 'package:verbatim_frontend/screens/signupErrorMessage.dart';
import 'package:verbatim_frontend/statsGameObject.dart';
import 'package:verbatim_frontend/widgets/check_unique_username_dialog.dart';
import 'package:http/http.dart' as http;

class GuestSignUpWithGoogle {
  GuestSignUpWithGoogle();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
        '1052195157201-9d7dskf4jihdd8b3ad6bmidnkoilu9ht.apps.googleusercontent.com',
  );

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

          String? username = await _getUniqueUsername(context);

          if (username != null && username.isNotEmpty) {
            guestSignUp(
                context, firstName, lastName, username, account.email, " ");
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
    List<String> nameParts = fullName.trim().split(' ');
    String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    String lastName = nameParts.length > 1 ? nameParts.last : '';
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

  void guestSignUp(BuildContext context, String firstName, String lastName,
      String username, String email, String password) async {
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
        'isLogin': false,
        'emailOrUsername': email,
        'password': password,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'withReferral': referer != '',
        'referringUsername': referer,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);
      responded = true;
      isGuest = true;

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

      window.sessionStorage['UserName'] = username;
      window.sessionStorage['FirstName'] = firstName;
      window.sessionStorage['LastName'] = lastName;
      window.sessionStorage['Bio'] = "";
      window.sessionStorage['Email'] = email;
      window.sessionStorage['Password'] = password;
      window.sessionStorage['ProfileUrl'] = 'assets/profile_pic.png';

      Navigator.pushNamed(context, '/global_challenge');
    } else {
      print('Error during sign-up: ${response.statusCode.toString()}');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const SignupErrorMessage(pageName: 'sign up'),
      ));
    }
  }
}
