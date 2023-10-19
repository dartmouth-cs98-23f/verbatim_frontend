import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'globalChallenge.dart';
import 'package:verbatim_frontend/main.dart';

class SideBar extends StatelessWidget {
  final List<Map<String, dynamic>> drawerItems = [
    {"title": "Global Challenge", "icon": Icons.home},
    {"title": "Group Name", "icon": Icons.people},
    {"title": "Friend Name", "icon": Icons.person},
    {"title": "Group Name", "icon": Icons.people},
    {"title": "Custom Challenge", "icon": Icons.lightbulb},
    {"title": "Create New Game", "icon": Icons.add},
    {"title": "Invite Friends", "icon": Icons.share},
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 64.0,
            child: DrawerHeader(
              child: Center(
                child:
                    Text('Categories', style: TextStyle(color: Colors.white)),
              ),
              decoration:
                  BoxDecoration(color: Color.fromARGB(94, 132, 31, 150)),
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0),
            ),
          ),
          ListView.builder(
            itemCount: drawerItems.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(drawerItems[index]["icon"]),
                title: Text(drawerItems[index]["title"]),
                onTap: () {
                  handleTap(context, index);
                },
              );
            },
          ),
        ],
      ),
    );
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
