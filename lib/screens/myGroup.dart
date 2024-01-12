import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/create_group_app_bar.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// my group is a page populated by the group-specific information
// it takes a ton of information...

/* Create Group:

frontend sends groupname, creator Username and added Usernames to the backend 

Backend returns the groupID, active challenges and groupMembers. 

I give myGroup:
- groupname
- active challenges
- group members
- group ID

once in myGroup, myGroup uses the ID to get the group stats from backend


*/

class myGroup extends StatefulWidget {
  final String groupName;
  final List<String> addedUsernames;

  myGroup({
    Key? key,
    required this.addedUsernames,
    required this.groupName,
  }) : super(key: key);

  @override
  _MyGroupState createState() => _MyGroupState();
}

class _MyGroupState extends State<myGroup> {
  Widget build(BuildContext context) {
    final String assetName = 'assets/img1.svg'; // orange (top) background

    return SafeArea(
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 243, 238),
            body: SingleChildScrollView(
                child: Container(
                    color: Color.fromARGB(255, 255, 243, 238),
                    child: Column(children: [
                      SizedBox(
                          width: double.maxFinite,
                          child: Column(children: [
                            SizedBox(
                                height: 240.v,
                                width: double.maxFinite,
                                child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      // orange background
                                      Container(
                                        height: 220.v,
                                        width: double.maxFinite,
                                        margin: EdgeInsets.zero,
                                        padding: EdgeInsets.zero,
                                        child: SvgPicture.asset(
                                          assetName,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      groupAppBar(title: widget.groupName)
                                    ]))
                          ]))
                    ])))));
  }
}
