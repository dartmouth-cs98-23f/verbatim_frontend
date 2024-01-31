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
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
      scrolledUnderElevation: 0.0,
      title: Container(
        height: 50,
        width: 180,
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
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => Size(
        mediaQueryData.size.width,
        height ?? 80.v,
      );
}
