import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyStatsTile extends StatelessWidget {
  final String stat;
  final String icon;
  final String field;
  const MyStatsTile(
      {required this.stat, required this.icon, required this.field});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        SvgPicture.asset(icon),
        const SizedBox(width: 15),
        Container(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10.0, left:15.0)),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: '$stat\n',
                    style: const TextStyle(
                        color: Colors.white,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                TextSpan(
                  text: field,
                  style: const TextStyle(
                      height: 1.2, color: Colors.white, fontSize: 12),
                )
              ])),
            ],
          ),
        ),
      ],
    );
  }
}
