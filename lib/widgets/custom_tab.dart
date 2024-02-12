import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlayTab extends StatefulWidget {
  final void Function(bool) onTabSelectionChanged;

  const PlayTab({Key? key, required this.onTabSelectionChanged}) : super(key: key);

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
    const String play = 'assets/playtoggle.svg';
    const String stats = 'assets/statstoggle.svg';
    Widget content = SvgPicture.asset(play, fit: BoxFit.fill);
    Widget content2 = SvgPicture.asset(stats, fit: BoxFit.fill);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          _toggleTabSelection(!_isFirstTabSelected);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 5,
                spreadRadius: -5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          width: double.infinity,
          height: double.infinity,
          child: _isFirstTabSelected ? content : content2,
        ),
      ),
    );
  }

  Widget _buildTabContent1(bool firsttab) {
    const String play = 'assets/playtoggle.svg';
    Widget content = SvgPicture.asset(play, fit: BoxFit.cover);

    return Visibility(
      visible: firsttab,
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: 60,
          width: 200,
          child: ClipOval(
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent2(bool secondtab) {
    const String stats = 'assets/statstoggle.svg';
    Widget content = SvgPicture.asset(stats, fit: BoxFit.cover);

    return Visibility(
      visible: secondtab,
      child: Center(
        child: SizedBox(
          height: 0,
          width: 0,
          child: ClipOval(child: content),
        ),
      ),
    );
  }

  Widget _buildTabContent(IconData icon, String text, double width) {
    const String stats = 'assets/statstoggle.svg';
    Widget content = SvgPicture.asset(stats, fit: BoxFit.cover);

    return Center(
      child: Container(
        height: 45,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
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
          renderBorder: true,
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
                    width: _isFirstTabSelected ? 100 : 50,
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
                    width: _isFirstTabSelected ? 50 : 100,
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
*/