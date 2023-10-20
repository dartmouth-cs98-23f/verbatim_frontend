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
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  void signUp(BuildContext context, username, String email, String password) async {
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

  void placeHolder(){
    print('Successfully signed up!');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              Text('Verbatim',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0.04,
                  letterSpacing: 0.10,
                ),
              ),

              const SizedBox(height: 180),

              Text('Create an account',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w700,
                  height: 0.04,
                  letterSpacing: 0.30,
                ),
              ),

              const SizedBox(height: 29),

              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 29),

              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 29),

              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 29),

              MyTextField(
                controller: passwordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 29),

              MyButton(
                buttonText: 'Create account',
                hasButtonImage: false, onTap: placeHolder,
              ),

              const SizedBox(height: 29),

              MyButton(
                buttonText: 'Sign up with Google',
                hasButtonImage: true,
                onTap: placeHolder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

