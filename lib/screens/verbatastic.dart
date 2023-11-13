import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verbatim_frontend/widgets/size.dart';

class Verbatastic extends StatelessWidget {
  final String verbatimedWord;
  final String formattedTimeUntilMidnight;
  final List<String>? verbatasticUsernames;

  Verbatastic({
    required this.verbatimedWord,
    required this.formattedTimeUntilMidnight,
    required this.verbatasticUsernames,
  });

  Future<void> preloadImages(BuildContext context) async {
    for (int i = 0; i < min(verbatasticUsernames!.length + 1, 6); i++) {
      final key = 'assets/Ellipse ${41 + i}.png';
      final image = AssetImage(key);
      await precacheImage(image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    preloadImages(context);

    return Column(
      children: [
        SizedBox(height: 20),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 100.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Verba',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '-tastic!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 65.v),
        Center(
            child: verbatasticUsernames!.isEmpty
                ? Container(
                    width: 100,
                    height: 48,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 30.0,
                          child: Image.asset(
                            'assets/Ellipse ${41}.png',
                            height: 48,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Container(
                      width: min(verbatasticUsernames!.length + 1, 6) * 38,
                      height: 45,
                      child: Stack(
                        children: [
                          for (int i = 0;
                              i < min(verbatasticUsernames!.length + 1, 6);
                              i++)
                            Positioned(
                              top: 0,
                              left: 30.0 * i,
                              child: Image.asset(
                                'assets/Ellipse ${41 + i}.png',
                                height: 45,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )),
        SizedBox(height: 10),
        Container(
          width: 200,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: verbatasticUsernames!.isEmpty
                  ? [
                      TextSpan(
                        text:
                            "Wow, you're unique! No other users have submitted any of these responses.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ]
                  : [
                      TextSpan(
                        text: 'You' +
                            (verbatasticUsernames!.length == 1
                                ? ' and '
                                : ', '),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      for (int i = 0;
                          i < min(verbatasticUsernames!.length, 5);
                          i++)
                        TextSpan(
                          text: verbatasticUsernames![i] +
                              (i < verbatasticUsernames!.length - 2
                                  ? ', '
                                  : i < verbatasticUsernames!.length - 1
                                      ? ' and '
                                      : ''),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      TextSpan(
                        text:
                            '${verbatasticUsernames!.length == 1 ? ' both ' : ' all '}said ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: verbatimedWord,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
            ),
          ),
        ),

        // section commented out until we implement 'similarity scores' :(
        /*
        Center(
          child: Container(
            width: 100.h,
            height: 55,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: (80.h - 45),
                  child: Image.asset(
                    'assets/Ellipse 41.png',
                    height: 55,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: (80.h - 45),
                  child: Image.asset('assets/Ellipse 47.png', height: 55),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 220,
          child: Center(
            child: RichText(
              text: TextSpan(
                children: verbatasticUsernames!.isEmpty
                    ? [
                        TextSpan(
                          text: 'Add some friends who think more like you!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ]
                    : [
                        TextSpan(
                          text: 'You were most similar to Sarah today, with a ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: '97%',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' similarity score!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
              ),
            ),
          ),
        ),
        */
        SizedBox(height: 50.v),
        Container(
          width: 220,
          child: Center(
            child: Text(
              'New Challenge in $formattedTimeUntilMidnight',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
