import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/Components/my_textfield.dart';

import '../Components/my_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                textAlign: TextAlign.center,
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
                hasButtonImage: false,
              ),

              const SizedBox(height: 29),

              MyButton(
                buttonText: 'Sign up with Google',
                hasButtonImage: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

