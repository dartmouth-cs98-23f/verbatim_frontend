import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'globalChallenge.dart';

class Draft extends StatefulWidget {
  const Draft({super.key});

  @override
  State<Draft> createState() => _Draft();
}

Future<String> fetchFromBackend() async {
  try {
    final response =
    await http.get(Uri.parse('http://localhost:8080/api/v1/helloWorld'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load album');
      return "response.body";
    }
  } catch (E) {
    return "something went wrong " + E.toString();
  }
}

void signUp(
    BuildContext context, username, String email, String password) async {
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
  } else {
    // Handle error
    print('Error during sign-up');
  }
}

class _Draft extends State<Draft> {
  int _counter = 0;
  late String _backendResponse = "";
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _incrementCounter() async {
    String response = await fetchFromBackend();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      _backendResponse = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                final username = usernameController.text;
                final email = emailController.text;
                final password = passwordController.text;
                signUp(context, username, email, password);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
