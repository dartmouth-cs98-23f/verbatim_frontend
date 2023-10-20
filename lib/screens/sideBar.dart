import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'globalChallenge.dart';
import 'package:verbatim_frontend/main.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 64.0,
            child: Center(
              child: DrawerHeader(
                child: Text('Jenny Linsky'),
              ),
            ),
          ),

          Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius value
                side: BorderSide(
                  color: Colors.black,
                  width: .75, // Border width
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
            child: ListTile(
              title: Text('Global Challenge'),
              leading: Icon(Icons.home, color: Colors.black),
              onTap: () {
                handleTap(context, 0);
              },
            ),
          ),
          SizedBox(height: 20.0),
          ExpansionTile(
            title: Text('Friends'),
            initiallyExpanded:
                true, // this will expand all of them - need to make a custom expansion tile at some point to fix this (i think)
            //leading: Icon(Icons.person, color: Colors.black),
            // trailing: Icon(Icons.add),
            shape: Border(),
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius value
                      side: BorderSide(
                        color: Colors.black,
                        width: .75,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text('Friend 1'),
                    leading: Icon(Icons.person, color: Colors.black),
                    onTap: () {},
                  ),
                ),
              ),
              SizedBox(height: 7.5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius value
                      side: BorderSide(
                        color: Colors.black,
                        width: .75,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text('Friend 2'),
                    leading: Icon(Icons.person, color: Colors.black),
                    onTap: () {},
                  ),
                ),
              ),
              SizedBox(height: 7.5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius value
                      side: BorderSide(
                        color: Colors.black,
                        width: .75,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text('Friend 3'),
                    leading: Icon(Icons.person, color: Colors.black),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.0),
          ExpansionTile(
            title: Text('Groups'),
            trailing: Icon(Icons.add),
            initiallyExpanded: true,
            shape: Border(),
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius value
                      side: BorderSide(
                        color: Colors.black,
                        width: .75,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
                  child: ListTile(
                    title: Text('Group 1'),
                    leading: Icon(Icons.people, color: Colors.black),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings, color: Colors.black),
            onTap: () {
              // Handle the "Settings" section tap
            },
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Adjust the radius value
                  side: BorderSide(
                    color: Colors.black,
                    width: .75,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
              child: ListTile(
                title: Text('Custom Challenge'),
                leading: Icon(Icons.play_arrow, color: Colors.black),
                onTap: () {},
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Adjust the radius value
                  side: BorderSide(
                    color: Colors.black,
                    width: .75,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: .1),
              child: ListTile(
                title: Text('Invite Friends'),
                leading: Icon(Icons.person_add, color: Colors.black),
                onTap: () {},
              ),
            ),
          ),
          // Add more sections and list items as needed
        ],
      ),
    ));
  }
}

void handleTap(BuildContext context, int index) {
  switch (index) {
    case 0: // "Global Challenge"
      navigatorKey.currentState!.pushNamed('/global_challenge');

      break;
    case 1: // "Group Name"
      Navigator.pushNamed(context, '/group_name');
      break;
    case 2: // "Friend Name"
      Navigator.pushNamed(context, '/friend_name');
      break;
    // Add cases for other items and routes
  }
}
