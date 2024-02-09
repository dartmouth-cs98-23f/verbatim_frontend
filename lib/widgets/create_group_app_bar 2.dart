import 'package:flutter/material.dart';
import 'size.dart';

class groupAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  groupAppBar({
    Key? key,
    this.height,
    required this.title,
  }) : super(
          key: key,
        );

  final double? height;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 100,
      elevation: 0,
      title: Container(
        height: 50,
        width: 160,
        alignment: Alignment(-2.0, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {},
        ),
      ],
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => Size(
        mediaQueryData.size.width,
        height ?? 80.v,
      );
}
