import 'package:flutter/material.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:verbatim_frontend/screens/myGroup.dart';

class customChallenge extends StatefulWidget {
  final String groupName;

  const customChallenge({
    Key? key,
    required this.groupName,
  }) : super(key: key);

  @override
  _CustomChallengeState createState() => _CustomChallengeState();
}

class _CustomChallengeState extends State<customChallenge>
    with SingleTickerProviderStateMixin {
  List<bool> expandedStates = [false, false, false];
  List<String> prompts = [
    "Replace with your challenge question",
    "Replace with your challenge question",
    "Replace with your challenge question",
  ];
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
                                const Text(
                                  'Custom Challenge',
                                  style: TextStyle(
                                    fontSize: 27,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 10.v),
                              ]))
                        ])),
                    // List of 5 rectangles
                    for (int i = 0; i < prompts.length; i++)
                      _buildEditableRectangle(i),
                    const SizedBox(height: 20),
                    //add prompt button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedStates.add(false);
                          prompts.add("Replace with your challenge question");
                          editingStates.add(false);
                        });
                        print('Add Prompt button pressed');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                          Icon(
                            Icons.add,
                            size: 20,
                            color: Color(0xFFE76F51),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Add Prompt',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE76F51),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                myGroup(groupName: widget.groupName),
                          ),
                        );
                      }, //send prompts to backend
                      child: const Text(
                        'Send Challenge!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
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
    TextEditingController editingController = TextEditingController(
      text: prompts[index],
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          expandedStates[index] = !expandedStates[index];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: expandedStates[index] ? 100 : 50,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.all(8),
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
            if (editingStates[index])
              Center(
                child: Row(children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE76F51),
                    radius: 10,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: editingController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onChanged: (editedText) {
                        prompts[index] = editedText;
                        editingStates[index] = false;
                      },
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ]),
              ),
            if (!editingStates[index])
              Center(
                child: Row(
                  children: [
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
                    const SizedBox(width: 10),
                    Text(
                      prompts[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (expandedStates[index])
              Positioned(
                bottom: 0,
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
                          width: 4,
                        ),
                        minimumSize: const Size(75, 35),
                      ),
                      onPressed: () {
                        setState(() {
                          prompts.removeAt(index);
                          expandedStates.removeAt(index);
                          editingStates.removeAt(index);
                        });
                      },
                      child: const Text('Delete',
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
                          minimumSize: const Size(75, 35),
                        ),
                        onPressed: () {
                          setState(() {
                            editingStates[index] = true;
                            prompts[index] = editingController.text;
                          });
                        },
                        child: const Text('Edit',
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
                          minimumSize: const Size(75, 35),
                        ),
                        onPressed: () {
                          setState(() {
                            editingStates[index] = false;
                            prompts[index] = editingController.text;
                            expandedStates[index] = false;
                          });
                        },
                        child: const Text('Save',
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
