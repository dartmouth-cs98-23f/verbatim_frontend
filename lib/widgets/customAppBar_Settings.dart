import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/profile.dart';
import 'package:verbatim_frontend/screens/settings.dart';
import 'package:verbatim_frontend/widgets/firebase_download_image.dart';
import 'size.dart';
import 'package:verbatim_frontend/screens/sideBar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomAppBarSettings extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  CustomAppBarSettings({
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 150,
      elevation: 0,
      title: Column(
        children: [
          SizedBox(height: 100),
          NewNavBar(),
          // SizedBox(height: 30), // Adjust the distance as needed

          TitleFrame(
            title: title,
            showBackArrow: showBackButton,
          ),
          SizedBox(height: 30),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size(
        mediaQueryData.size.width,
        80.v,
      );
}

class NewNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String profileUrl =
        SharedPrefs().getProfileUrl() ?? 'assets/profile_pic.png';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IconButton(
          //   icon: Icon(
          //     Icons.menu,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     // Navigate to the SideBar widget
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SideBar()),
          //     );
          //   },
          // ),
          // SearchBarTextField(),
          SizedBox(width: 80),
          FirebaseStorageImage(
            profileUrl: profileUrl,
          ),
        ],
      ),
    );
  }
}

class SearchBarTextField extends StatelessWidget {
  TextEditingController _searchController = TextEditingController();

  void handleSearch(String value) {
    // Handle the search input changes
    print("Search onChanged: $value");
  }

  void handleSubmit(String value) {
    // Handle the search submission
    print("Search onSubmitted: $value");
  }

  void handleSearchIconPressed() {
    // Handle the search icon pressed
    print("Search icon pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      fit: FlexFit.tight,
      child: Container(
        width: 380,
        height: 30,
        padding: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Color(0xFFFFF7EE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(width: 8), // Adjust horizontal spacing as needed
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: handleSearch,
                  onSubmitted: handleSubmit,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0.11,
                    letterSpacing: 0.20,
                  ),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'Search Users',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0.11,
                      letterSpacing: 0.20,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleFrame extends StatelessWidget {
  final String title;
  final bool showBackArrow;

  TitleFrame({required this.title, this.showBackArrow = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 357,
      height: 70,
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (showBackArrow)
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFF7EE)),
                onPressed: () {
                  // Handle back arrow press
                  Navigator.pop(context);
                },
              ),
            ),
          SizedBox(width: showBackArrow ? 15.0 : 0.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.0),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFFFFF7EE),
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0.04,
                  letterSpacing: 0.10,
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ],
      ),
    );
  }
}
