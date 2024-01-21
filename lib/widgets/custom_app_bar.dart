import 'package:flutter/material.dart';
import 'size.dart';
import 'package:verbatim_frontend/widgets/my_textfield.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.height,
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
        width: 140,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 25, width: 8),
            Icon(Icons.search, color: Colors.grey, size: 15),
            SizedBox(height: 25, width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 14.0),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 0),
                ),
                textAlign: TextAlign.left,
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
