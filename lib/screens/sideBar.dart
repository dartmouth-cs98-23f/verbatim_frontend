import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final Color primary = Color.fromARGB(255, 231, 111, 81);
  final String username;

  SideBar({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
            child: Container(
                height: 64,
                decoration: ShapeDecoration(
                  color: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Center(
                  child: ListTile(
                    title: Text(
                      '$username',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    leading: Icon(Icons.mood, color: Colors.white, size: 32),
                    trailing:
                        Icon(Icons.settings, color: Colors.white, size: 26),
                    onTap: () {
                      handleTap(context, 2);
                    },
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: primary,
                    width: 1.5,
                  ),
                ),
              ),
              child: ListTile(
                title: Text('Global Challenge',
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                leading: Icon(Icons.home, color: primary),
                onTap: () {
                  handleTap(context, 0);
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
          ExpansionTile(
            title: Text('Friends',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),

            trailing: GestureDetector(
              onTap: () {
                handleTap(context, 1);
              },
              child: Icon(Icons.add, color: Colors.black, size: 25),
            ),

            initiallyExpanded:
                true, // this will expand all of them - need to make a custom expansion tile at some point to fix this (i think)

            shape: Border(),
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  child: ListTile(
                    title: Text('Friend 1',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    leading: Icon(Icons.person, color: Colors.black),
                    onTap: () {},
                  ),
                ),
              ),
              SizedBox(height: 7.5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  child: ListTile(
                    title: Text('Friend 2',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    leading: Icon(Icons.person, color: Colors.black),
                    onTap: () {},
                  ),
                ),
              ),
              SizedBox(height: 7.5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  child: ListTile(
                    title: Text('Friend 3',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    leading: Icon(Icons.person, color: Colors.black),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          ExpansionTile(
            title: Text(
              'Groups',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            trailing: Icon(Icons.add, color: Colors.black, size: 25),
            initiallyExpanded: true,
            shape: Border(),
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
                  child: ListTile(
                    title: Text('Group 1',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    leading: Icon(Icons.people, color: Colors.black),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          ListTile(
            title: Text('More',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            onTap: () {
              // Handle the "More" section tap
            },
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
              child: ListTile(
                title: Text('Custom Challenge',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                leading: Icon(Icons.play_arrow, color: Colors.black),
                onTap: () {},
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
              child: ListTile(
                title: Text('Invite Friends',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                leading: Icon(Icons.person_add, color: Colors.black),
                onTap: () {},
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

void handleTap(BuildContext context, int index) {
  switch (index) {
    case 0: // "Global Challenge"
      // ignore: prefer_typing_uninitialized_variables
      Navigator.pushNamed(context, '/global_challenge');
      break;
    case 1: // "Group Name"
      Navigator.pushNamed(context, '/add_friend');
      break;
    case 2: // "Settings"
      Navigator.pushNamed(context, '/settings');
      break;
    // Add cases for other routes
  }
}
