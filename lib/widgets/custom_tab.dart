import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    if (_isFirstTabSelected != isFirstTabSelected) {
      widget.onTabSelectionChanged(isFirstTabSelected);
      setState(() {
        _isFirstTabSelected = isFirstTabSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String play = 'assets/play.png';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: 60,
        width: 200,
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
        child: Center(
            child: ToggleButtons(
          isSelected: [_isFirstTabSelected, !_isFirstTabSelected],
          fillColor: Colors.orange[800],
          renderBorder: false,
          onPressed: (int index) {
            _toggleTabSelection(index == 0);
          },
          children: [
            /*
            Container(
              height: 45,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: SvgPicture.asset(
                play,
                fit: BoxFit.fill,
              ),
            ),
            */

            Center(
                child: Container(
                    height: 45,
                    width: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(
                            Icons.lightbulb,
                            color: Colors.black,
                          ),
                          Text("Play",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black))
                        ])))),
            Center(
                child: Container(
                    height: 45,
                    width: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: Colors.black,
                            ),
                            Text("Stats",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black))
                          ]),
                    )))
          ],
        )),
      ),
    );
  }
}
