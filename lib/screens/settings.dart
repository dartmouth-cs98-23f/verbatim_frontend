import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/widgets/my_textfield.dart';
import 'sideBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/custom_tab.dart';
import 'dart:async';
import 'package:verbatim_frontend/Components/shared_prefs.dart';


//get the edits to send back as an acoount settings thing
//getsignin -> look for input function to replace




Future<void> edits(BuildContext context,
  String firstName,
  String lastName,
  String username,
  String newUsername,
  String bio,
  String email,
  String profilePic,
)


async {
  try{
    final response = await http.post(Uri.parse('http://localhost:8080/api/v1/accountSettings'),
    headers: <String, String>{
    'Content-Type': 'application/json',
  },
  body: jsonEncode({
    'firstName': firstName,
    'lastName': lastName,
    'username': username,
    'newUsername': newUsername,
    'email':email,
    'bio': bio,
    'profilePic': profilePic,
    }),
    );
  //do sth to verify the response,
  }


  catch(error){
    print('Sorry cannot edit account settings:$error');
  }


}


//get the account info to display as dummy text




class settings extends StatefulWidget {
  const settings({super.key});


  @override
  State<settings> createState() => _SettingsState();
}


class _SettingsState extends State<settings> {


  final firstNameSettings = TextEditingController();
  final lastNameSettings = TextEditingController();


  final usernameSettings = TextEditingController();
  final bioSettings = TextEditingController();
  final emailSettings = TextEditingController();
  final String assetName = 'assets/img1.svg';


@override
Widget build(BuildContext context) {


// TODO: implement build
  return SafeArea(
    child: Scaffold
    (
    resizeToAvoidBottomInset: false,
    body: SafeArea(
    child: Container(


    color: Color.fromARGB(255, 255, 243, 238),
    child: Column(
    children:
    [
    SizedBox(
    width: double.maxFinite,
    child: Column(
    children: [
    SizedBox(
    height: 300.v,
    width: double.maxFinite,
    child: Stack(
    alignment: Alignment.bottomLeft,
    children: [
    // orange background
    Container(
    height: 300.v,
    width: double.maxFinite,
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    child: SvgPicture.asset(
    assetName,
    fit: BoxFit.fill,
    ),
    ),


    // app bar on top of background
    CustomAppBar(),


    // 'Account Settings #'
    Positioned(
    child: Center(
    child: Text(
    'Account Settings',
    style: TextStyle(
    fontSize: 28,
    color: Colors.white,
    fontWeight: FontWeight.w900,
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ],
    )),
    const SizedBox(height: 42),
    Padding(
    padding: const EdgeInsets.only(left: 30.0),
    child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
    'First Name',
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


    const SizedBox(height: 20),
    MyTextField(controller: firstNameSettings,
    hintText: SharedPrefs().getFirstName() ?? "",
    obscureText: false),


    //last name
    const SizedBox(height: 42),
    Padding(
    padding: const EdgeInsets.only(left: 30.0),
    child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
    'Last Name',
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


    const SizedBox(height: 20),
    MyTextField(controller: lastNameSettings,
    hintText: SharedPrefs().getLastName() ??"",
    obscureText: false),


    //username
    const SizedBox(height: 42),
    Padding(
    padding: const EdgeInsets.only(left: 30.0),
    child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
    'Username',
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
    const SizedBox(height: 20),
    MyTextField(controller: usernameSettings,
    hintText: SharedPrefs().getUserName()??"",
    obscureText: false),


    //bio
    const SizedBox(height: 42),
    Padding(
    padding: const EdgeInsets.only(left: 30.0),
    child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
    'Bio',
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
    const SizedBox(height: 20),
    MyTextField(controller: bioSettings,
    hintText: SharedPrefs().getBio()??"",
    obscureText: false),


    //email
    //bio
    const SizedBox(height: 42),
    Padding(
    padding: const EdgeInsets.only(left: 30.0),
    child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
    'Email',
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
    const SizedBox(height: 20),
    MyTextField(controller: emailSettings,
    hintText: SharedPrefs().getEmail()??"",
    obscureText: false),
    ]
    )
    )


    )




    )
    );
  }


}
