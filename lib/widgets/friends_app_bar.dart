import 'package:flutter/material.dart';
import 'size.dart';

class FriendsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FriendsAppBar({
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
      scrolledUnderElevation: 0.0,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      title: Container(
        height: 50,
        width: 160,
        alignment: const Alignment(-2.0, 0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'Add Friends',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
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
