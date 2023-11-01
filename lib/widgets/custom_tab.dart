import 'package:flutter/material.dart';

class PlayTab extends StatefulWidget {
  final void Function(bool) onTabSelectionChanged;

  PlayTab({Key? key, required this.onTabSelectionChanged}) : super(key: key);

  @override
  _PlayTabState createState() => _PlayTabState();
}

class _PlayTabState extends State<PlayTab> {
  late bool _isFirstTabSelected;

  @override
  void initState() {
    super.initState();
    _isFirstTabSelected = true;
  }

  void _toggleTabSelection(bool isFirstTabSelected) {
    widget.onTabSelectionChanged(isFirstTabSelected);
    setState(() {
      _isFirstTabSelected = isFirstTabSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: 30,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
              offset: Offset(3, 7),
            ),
          ],
        ),
        child: ToggleButtons(
          isSelected: [_isFirstTabSelected, !_isFirstTabSelected],
          selectedColor: Colors.black,
          fillColor: Colors.orange[800],
          borderRadius: BorderRadius.circular(50),
          onPressed: (int index) {
            _toggleTabSelection(index == 0);
          },
          children: [
            Icon(
              Icons.lightbulb,
              color: Colors.black,
            ),
            Icon(
              Icons.bar_chart,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
