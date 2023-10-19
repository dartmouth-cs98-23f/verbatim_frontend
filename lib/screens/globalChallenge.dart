import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sideBar.dart';
import 'package:verbatim_frontend/main.dart';

class globalChallenge extends StatefulWidget {
  @override
  _GlobalChallengeState createState() => _GlobalChallengeState();
}

class _GlobalChallengeState extends State<globalChallenge> {
  String userResponse = ''; // Variable to store the user's response
  TextEditingController responseController = TextEditingController();

  bool response = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verbatim')),
      drawer: SideBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sports that start with "T"'),
            SizedBox(height: 20.0),
            response
                ? Text('Your Response: $userResponse')
                : Column(
                    children: [
                      TextField(
                        controller: responseController,
                        onChanged: (value) {
                          setState(() {
                            userResponse = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your response',
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Visibility(
                        visible:
                            !response, // Show the button when response is false
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              userResponse = responseController.text;
                              responseController.clear();
                              response = true;
                            });
                          },
                          child: Text('Enter'),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
