import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verbatim_frontend/widgets/my_button_with_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/my_button_with_image.dart';
import 'package:clipboard/clipboard.dart';


class Verbatastic extends StatelessWidget {
  final String verbatimedWord;
  final String formattedTimeUntilMidnight;
  final List<String>? verbatasticUsernames;

  Verbatastic({
    required this.verbatimedWord,
    required this.formattedTimeUntilMidnight,
    required this.verbatasticUsernames,
  });

  void copyInvite() {
    //TODO
    String inviteLink = 'testlink';
    Clipboard.setData(new ClipboardData(text: inviteLink));
  }

  void sendInvite() {
    //new dialogue box, takes in phone number, get the pop up from existing code
  }
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
    String copyIcon = 'assets/copy.svg';
    String sendIcon = 'assets/send.svg';
    String inviteText = "\n See how your friends would compare!";
  
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
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: verbatimedWord,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
            ),
          ),
          //add the buttons
        ),
        const SizedBox(height: 10),
        Text(
          inviteText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 25),
        MyButtonWithSvg(
            buttonText: "Copy Invite Link",
            iconImage: copyIcon,
            onTap: copyInvite),
        // const SizedBox(height: 10),
        // MyButtonWithSvg(
        //     buttonText: "Send Invite", iconImage: sendIcon, onTap: sendInvite),
        SizedBox(height: 50.v),
        Container(
          width: 220,
          child: Center(
            child: Text(
              'New Challenge in $formattedTimeUntilMidnight',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
