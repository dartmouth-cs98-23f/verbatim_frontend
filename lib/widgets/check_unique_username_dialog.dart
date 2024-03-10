import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/widgets/errorDialog.dart';
import 'package:http/http.dart' as http;

class CheckUsernameDialog {
  List<String> userUsernames = [];

  Future<String?> show(
      BuildContext context, TextEditingController usernameController) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Set the corner radius
          ),
          backgroundColor: const Color.fromARGB(255, 255, 243, 238),
          // Set the background color
          title: Text('Enter Username',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.orange,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )),
          content: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: 'Username',
              hintStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Color(0xFF6C7476),
                  fontFamily: 'Poppins',
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Color(0xFFE76F51), // Specify the border color
                ),
              ),
            ),
          ),

          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Check if username is unique
                bool isUnique =
                    await checkUsernameUnique(usernameController.text);
                if (isUnique) {
                  Navigator.pop(context, usernameController.text);
                } else {
                  ErrorDialog.show(context,
                      'This username is already taken. Choose a different one.');
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to check if username is unique
  Future<bool> checkUsernameUnique(String username) async {
    await getUsers(); // Fetch list of existing usernames
    return !userUsernames.contains(username.toLowerCase());
  }

  // Function to get all users to display
  Future<void> getUsers() async {
    final url = Uri.parse('${BackendService.getBackendUrl()}users');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("response successful");
      final List<dynamic> data = json.decode(response.body);
      final List<User> userList =
          data.map((item) => User.fromJson(item)).toList();

      userUsernames =
          userList.map((user) => user.username.toLowerCase()).toList();

      print("\n Existing usernames are ${userUsernames} \n");
    } else {
      print("failure");
    }
  }
}
