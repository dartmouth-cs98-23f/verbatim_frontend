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
        //const SizedBox(width: 15),
        Container(
          //widthFactor: 0.5,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 15.0)),
              Text(stat,
                  //textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Row(children: [
                              const SizedBox(width: 25),

              Positioned(
                bottom: 15,
                child: Text(field,
                    //textAlign: TextAlign.left,
                    softWrap: true,
                    style: const TextStyle(
                        height: 1.2, color: Colors.white, fontSize: 14)),
              ),
              ],)

            ],
          ),
        ),
      ],
    );
  }
}
