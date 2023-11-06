import 'package:flutter/material.dart';




class testCustomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 100,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Implement your back button functionality here
        },
      ),
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search users',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            // Implement your profile icon functionality here
          },
        ),
      ],
    );
  }
}
