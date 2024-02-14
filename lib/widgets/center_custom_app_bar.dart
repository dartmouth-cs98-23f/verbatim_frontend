import 'package:flutter/material.dart';
import 'size.dart';

class centerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const centerAppBar({
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
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 29,
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size(
        mediaQueryData.size.width,
        height ?? 80.v,
      );
}
