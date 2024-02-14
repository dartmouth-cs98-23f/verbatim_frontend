import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verbatim_frontend/widgets/donutChart.dart';
import 'package:verbatim_frontend/widgets/size.dart';

class StatsContent extends StatelessWidget {
  final List<String> verbaMatchStatsContent;
  final double groupRating;

  StatsContent({
    Key? key,
    required this.verbaMatchStatsContent,
    required this.groupRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEmpty = verbaMatchStatsContent.isEmpty;
    String verb1 = isEmpty ? '' : verbaMatchStatsContent[0];
    String verb2 = isEmpty ? '' : verbaMatchStatsContent[1];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DonutChart(
                groupSimilarity: groupRating,
                title: 'Group Power Score',
              ),
            ),
          ),
          SizedBox(height: 15.v),
          Visibility(
            visible: !isEmpty,
            child: Container(
              child: const Center(
                child: Text(
                  'Most Similar: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isEmpty,
            child: Container(
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'No ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Verba-',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Matches...',
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
          ),
          Visibility(
            visible: isEmpty,
            child: const SizedBox(
              height: 20,
            ),
          ),
          Visibility(
            visible: isEmpty,
            child: Container(
              child: const Center(
                child: Text(
                  'Play more challenges to match!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isEmpty,
            child: Container(
              child: RichText(
                text: const TextSpan(
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
                      text: 'Match!',
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
          Visibility(
            visible: !isEmpty,
            child: SizedBox(height: 10.v),
          ),
          Visibility(
            visible: verbaMatchStatsContent.isNotEmpty,
            child: SizedBox(
              width: 170,
              height: 60,
              child: Stack(
                children: [
                  for (int i = 0;
                      i < min(verbaMatchStatsContent.length, 2);
                      i++)
                    Positioned(
                      top: 0,
                      left: 35.0 + (i * 50),
                      child: Image.asset(
                        'assets/Ellipse ${41 + i}.png',
                        height: 60,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !isEmpty,
            child: SizedBox(height: 15.v),
          ),
          Visibility(
            visible: !isEmpty,
            child: verbaMatchStatsContent.isNotEmpty
                ? Container(
                    child: Center(
                      child: Text(
                        '$verb1 and $verb2',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : SizedBox(), // Empty SizedBox to render nothing if verbaMatchStatsContent is empty
          ),
          SizedBox(height: 50.v)
        ],
      ),
    );
  }
}
