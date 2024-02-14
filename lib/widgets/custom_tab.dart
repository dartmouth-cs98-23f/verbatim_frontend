import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class PlayTab extends StatefulWidget {
  final void Function(bool) onTabSelectionChanged;
<<<<<<< HEAD

  const PlayTab({Key? key, required this.onTabSelectionChanged}) : super(key: key);

=======
  PlayTab({Key? key, required this.onTabSelectionChanged}) : super(key: key);
>>>>>>> main
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
    Widget content2 = SvgPicture.asset(
      stats,
      fit: BoxFit.fill,
    );
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
          color: Colors.transparent,
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
<<<<<<< HEAD
        child: SizedBox(
=======
        child: Container(
          color: Colors.transparent,
>>>>>>> main
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



