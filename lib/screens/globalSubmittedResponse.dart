import 'package:flutter/material.dart';
import 'package:verbatim_frontend/gameObject.dart';
import 'package:verbatim_frontend/statsGameObject.dart';
import 'package:verbatim_frontend/widgets/stats.dart';

class globalSubmittedResponse extends StatefulWidget {
  const globalSubmittedResponse({
    Key? key,
  }) : super(key: key);

  @override
  _GlobalSubmittedResponseState createState() =>
      _GlobalSubmittedResponseState();
}

class _GlobalSubmittedResponseState extends State<globalSubmittedResponse> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          width: 350,
          height: 500,
          child: Stats(
              totalResponses: totalResponses,
              tabLabels: [
                categoryQ1,
                categoryQ2,
                categoryQ3,
                categoryQ4,
                categoryQ5
              ],
              statsQ1: statsQ1,
              statsQ2: statsQ2,
              statsQ3: statsQ3,
              statsQ4: statsQ4, // two more for +2!
              statsQ5: statsQ5,
              questions: [
                question1,
                question2,
                question3,
                question4,
                question5
              ],
              responses: [
                responseQ1,
                responseQ2,
                responseQ3,
                responseQ4,
                responseQ5
              ]))
    ]);
  }
}
