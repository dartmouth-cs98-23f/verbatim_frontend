import 'package:flutter/material.dart';
import 'sideBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/friends_app_bar.dart';
import 'package:verbatim_frontend/widgets/size.dart';

class addFriend extends StatefulWidget {
  final String username;

  addFriend({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<addFriend> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  // all of the user's that aren't friends with this user - need via backend
  List<String> _data = [
    "Abigail Smith",
    "Benjamin Johnson",
    "Charlotte Williams",
    "Daniel Brown",
    "Elizabeth Jones",
    "Harper Martinez",
    "David Robinson",
    "Madison Davis",
    "Oliver Scott",
    "Scarlett Lopez",
    "Samuel Perez",
    "Amelia Young",
    "William Hall",
    "Zoe Baker",
    "Joseph Wright",
    "Grace Taylor",
    "Benjamin Lewis",
    "Sophia Allen",
    "Daniel Walker",
    "Emma Harris",
    "Joseph Perez",
    "Abigail Wright",
    "Noah Taylor",
    "Mia White",
    "Oliver Thomas",
    "Amelia Wilson",
  ];
  List<String> _selectedFriends = [];

// suggested - need to come in through backend
  List<String> _suggestedNames = [
    "Zoe Clark",
    "Sophia Thomas",
    "William Scott",
    "Harper King",
    "Alexander Baker",
    "Lily Martinez",
    "Daniel Nelson",
    "Mia Lee",
    "Joseph Young",
    "Victoria Jackson",
    "James Adams",
    "Scarlett Davis",
    "Samuel Thomas",
    "Sofia Robinson",
    "Ethan Walker"
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFriend(String friendName) {
    setState(() {
      if (_selectedFriends.contains(friendName)) {
        _selectedFriends.remove(friendName);
      } else {
        _selectedFriends.add(friendName);
      }
    });
  }

  List<String> _searchResults() {
    return _data
        .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  void _addFriend(String friendName) {
    if (!_selectedFriends.contains(friendName)) {
      setState(() {
        _selectedFriends.add(friendName);
      });
    }
  }

  Widget build(BuildContext context) {
    final String assetName = 'assets/img1.svg';

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 255, 243, 238),
      body: SingleChildScrollView(
        child: Container(
            color: Color.fromARGB(255, 255, 243, 238),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 240.v,
                        width: double.maxFinite,
                        child: Stack(alignment: Alignment.topCenter, children: [
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
                          FriendsAppBar(),

                          Padding(
                            padding: EdgeInsets.only(
                                top:
                                    20.0), // Adjust the top padding value as needed
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: 350,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 8),
                                      Icon(Icons.search, color: Colors.black),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            hintText: "Search User",
                                            hintStyle: const TextStyle(
                                                fontSize: 14.0,
                                                color: Color.fromARGB(
                                                    255, 6, 5, 5)),
                                            border: InputBorder.none,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: 200,
                              margin: EdgeInsets.only(left: 32),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    if (_searchText.isNotEmpty)
                                      TextSpan(
                                        text: "Search Results",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    else
                                      TextSpan(
                                        text: "People you may know:",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 117, 19, 12)
                              .withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(3, 7),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: _searchText.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults().length,
                            itemBuilder: (context, index) {
                              final friendName = _searchResults()[index];
                              final isFriend =
                                  _selectedFriends.contains(friendName);
                              return ListTile(
                                  title: Row(
                                    children: [
                                      Icon(Icons.mood),
                                      SizedBox(width: 8),
                                      Text(
                                        friendName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: isFriend
                                        ? Icon(Icons.remove)
                                        : Icon(Icons.person_add_alt),
                                    onPressed: () {
                                      _toggleFriend(friendName);
                                    },
                                  ));
                            },
                          )
                        : ListView.builder(
                            itemCount: _suggestedNames.length,
                            itemBuilder: (context, index) {
                              final name = _suggestedNames[index];
                              final isFriend = _selectedFriends.contains(name);

                              return ListTile(
                                  title: Row(
                                    children: [
                                      Icon(Icons.mood),
                                      SizedBox(width: 8),
                                      Text(
                                        name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: isFriend
                                        ? Icon(Icons.remove)
                                        : Icon(Icons.person_add_alt),
                                    onPressed: () {
                                      _toggleFriend(name);
                                    },
                                  ));
                            },
                          ),
                  ),
                ),
              ],
            )),
      ),
      drawer: SideBar(username: widget.username),
    ));
  }
}
