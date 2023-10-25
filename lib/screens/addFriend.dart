import 'package:flutter/material.dart';
import 'sideBar.dart';

class addFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<addFriend> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  // all of the user's that aren't friends with this user
  List<String> _data = [
    "Sandy W.",
    "Slinky M.",
    "Hokus P.",
    "Elliott S.",
    "Aimee M.",
    "Rolling S.",
    "Alice D."
  ];
  List<String> _selectedFriends = [];

  List<String> _suggestedNames = ["Karen S.", "Jen W.", "Harry W."];

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
    return Scaffold(
        //Constant features: Title, sidebar, alarm icon

        //Title: Verbatim
        appBar: AppBar(
          title: Container(
            height: 50,
            width: 220,
            alignment: Alignment(-2.0, 0.0),
            child: Image.asset('assets/Logo.png', fit: BoxFit.contain),
          ),
          //left hand corner: alarm icon
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_alert),
              onPressed: () {},
            ),
          ],
          centerTitle: false,
        ),
        //Sidebar implemented from sideBar.dart
        drawer: SideBar(),
        //search field
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Users',
              ),
            ),
          ),
          //show list of users to add as friends
          if (_searchText.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults().length,
              itemBuilder: (context, index) {
                final friendName = _searchResults()[index];
                final isFriend = _selectedFriends.contains(friendName);
                return ListTile(
                  title: Text(friendName),
                  trailing: isFriend
                      ? IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {},
                        )
                      : IconButton(
                          icon: Icon(Icons.person_add_alt),
                          onPressed: () {
                            _addFriend(friendName);
                          },
                        ),
                );
              },
            )
          //otherwise show suggested friends
          else if (_searchText.isEmpty)
            Text(
              'Suggested Friends:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _suggestedNames.length,
            itemBuilder: (context, index) {
              final name = _suggestedNames[index];
              final isFriend = _selectedFriends.contains(name);

              return ListTile(
                title: Text(name),
                trailing: IconButton(
                  icon: isFriend
                      ? Icon(Icons.remove)
                      : Icon(Icons.person_add_alt),
                  onPressed: () {
                    _toggleFriend(name);
                  },
                ),
              );
            },
          )
        ])));
  }
}

class friendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text('')));
  }
}
