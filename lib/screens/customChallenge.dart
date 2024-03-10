import 'dart:html';

import 'package:flutter/material.dart';
import 'package:verbatim_frontend/BackendService.dart';
//import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:verbatim_frontend/screens/myGroup.dart';
import 'package:verbatim_frontend/screens/friendship.dart';

Future<void> createCustomChallenge(
    String username, List<String> prompts, int groupId) async {
  final url =
      Uri.parse('${BackendService.getBackendUrl()}createCustomChallenge');
  final headers = <String, String>{'Content-Type': 'application/json'};

  final response = await http.post(url,
      headers: headers,
      body: json.encode({
        'createdByUsername': username,
        'questions': prompts,
        'groupId': groupId
      }));
  if (response.statusCode == 200) {
  } else {
    print(
        'failed to create standard challenge. Status code: ${response.statusCode}');
  }
}

class customChallenge extends StatefulWidget {
  final String groupName;
  final int? groupId;
  final bool friendship;

  const customChallenge({
    Key? key,
    required this.groupName,
    required this.groupId,
    required this.friendship,
  }) : super(key: key);

  @override
  _CustomChallengeState createState() => _CustomChallengeState();
}

class _CustomChallengeState extends State<customChallenge>
    with SingleTickerProviderStateMixin {
  // track whether each rectangle is exanded or not
  List<bool> expandedStates = [false, false, false];

  // list of prompts the user will input
  // whatever the prompts hinttext is make sure that the hinttext string stats the same!
  String hintText = "Enter your challenge question...";
  List<String> prompts = [
    "Enter your challenge question...",
    "Enter your challenge question...",
    "Enter your challenge question...",
  ];

// r they ready for the bird?!?!?!
  List<bool> bird = [false, false, false];

  //whether each is in 'editing' mode
  List<bool> editingStates = [false, false, false];

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/img1.svg';

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 243, 238),
        body: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 255, 243, 238),
            child: Column(children: [
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(
                        height: 280.v,
                        width: double.maxFinite,
                        child: Stack(alignment: Alignment.topCenter, children: [
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
                          const CustomAppBar(),
                          Container(
                              margin: EdgeInsets.only(top: 100.v),
                              child: Column(children: [
                                Text(
                                  'Custom Challenge',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 27,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.v),
                              ]))
                        ])),
                    //  5 rectangles
                    for (int i = 0; i < prompts.length; i++)
                      _buildEditableRectangle(i),
                    const SizedBox(height: 20),
                    //add prompt button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedStates.add(false);
                          prompts.add("Enter your challenge question...");
                          editingStates.add(false);
                          bird.add(false);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.add,
                            size: 20,
                            color: Color(0xFFE76F51),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Add Prompt',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE76F51),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFE76F51),
                        enableFeedback: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(150, 50),
                      ),
                      // add 'create challenge'
                      onPressed: () {
                        if (widget.friendship) {
                          int groupID = widget.groupId!;
                          String name = widget.groupName;
                          String username =
                              window.sessionStorage['UserName'] ?? "";
                          Navigator.pop(context);
                          createCustomChallenge(username, prompts, groupID)
                              .then((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => friendship(
                                  friendUsername: name,
                                ),
                              ),
                            );
                          });
                        } else {
                          int groupID = widget.groupId!;
                          String username =
                              window.sessionStorage['UserName'] ?? "";
                          Navigator.pop(context);
                          createCustomChallenge(username, prompts, groupID)
                              .then((_) {
                            //send custom challenge to the backend
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => myGroup(
                                    groupName: widget.groupName,
                                    groupId: widget.groupId),
                              ),
                            );
                          });
                        }
                      }, //send prompts to backend
                      child: Text(
                        'Send Challenge!',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ]),
          ),
        ),
        drawer: const SideBar(),
        // fix the positioning here
      ),
    );
  }

  Widget _buildEditableRectangle(int index) {
    // the text to be edited is the prompt clicked on
    TextEditingController editingController = TextEditingController(
      text: (prompts[index] == 'Enter your challenge question...')
          ? null
          : prompts[index],
    );

    FocusNode focusNode = FocusNode();
    return GestureDetector(
      onTap: () {
        setState(() {
          expandedStates[index] = !expandedStates[index];
          editingStates[index] = !editingStates[index];
          focusNode.requestFocus();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: expandedStates[index] ? 100 : 50,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9E503C).withOpacity(1),
              blurRadius: 5,
              offset: const Offset(2, 3),
            )
          ],
        ),
        child: Stack(
          children: [
            // if we are editing the rectangle
            if (editingStates[index])
              // make the circle avatar orange

              Center(
                child: Row(children: [
                  if (!bird[index])
                    const CircleAvatar(
                      backgroundColor: Color(0xFFE76F51),
                      radius: 10,
                    ),
                  if (bird[index])
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12,
                      child: Image.asset('assets/bird.png'),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      autofocus: true,
                      controller: editingController,
                      decoration: const InputDecoration(
                        hintText: "Enter your challenge question...",
                        border: InputBorder.none,
                      ),
                      onChanged: (editedText) {
                        prompts[index] = editedText;
                      },
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            if (!editingStates[index])
              Center(
                child: Row(
                  children: [
                    if (!bird[index])
                      CircleAvatar(
                          foregroundColor: const Color(0xFFE76F51),
                          backgroundColor: const Color(0xFFE76F51),
                          radius: 10,
                          child: CircleAvatar(
                            backgroundColor: expandedStates[index]
                                ? const Color(0xFFE76F51)
                                : Colors.white,
                            radius: 9,
                          )),
                    if (bird[index])
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Image.asset('assets/bird.png'),
                      ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        prompts[index],
                        style: prompts[index] == hintText
                            ? GoogleFonts.poppins(
                                textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                                overflow: TextOverflow.ellipsis,
                              ))
                            : GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              )),
                      ),
                    ),
                  ],
                ),
              ),
            if (expandedStates[index])
              Positioned(
                bottom: 3,
                right: 0,
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFFE76F51),
                        backgroundColor: Colors.white,
                        enableFeedback: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(
                          color: Color(0xFFE76F51),
                          width: 3,
                        ),
                        minimumSize: const Size(50, 20),
                      ),
                      onPressed: () {
                        setState(() {
                          prompts.removeAt(index);
                          expandedStates.removeAt(index);
                          editingStates.removeAt(index);
                          bird.removeAt(index);
                        });
                      },
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (!editingStates[index])
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFE76F51),
                          enableFeedback: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(50, 20),
                        ),
                        onPressed: () {
                          setState(() {
                            editingStates[index] = true;
                            prompts[index] = editingController.text;
                          });
                        },
                        child: Text(
                          'Edit',
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                      ),
                    if (editingStates[index])
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFE76F51),
                          enableFeedback: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(50, 20),
                        ),
                        onPressed: () {
                          setState(() {
                            editingStates[index] = false;
                            prompts[index] = editingController.text;
                            expandedStates[index] = false;
                            bird[index] = true;
                          });
                        },
                        child: Text(
                          'Save',
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                      ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
