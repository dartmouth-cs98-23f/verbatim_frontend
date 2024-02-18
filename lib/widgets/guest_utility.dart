import 'package:flutter/material.dart';
import 'package:verbatim_frontend/gameObject.dart';
import 'package:verbatim_frontend/statsGameObject.dart';

class GuestUtility {

  void clearGameObject() {
    responseQ1 = '';
    responseQ2 = '';
    responseQ3 = '';
    responseQ4 = '';
    responseQ5 = '';
    referer = '';
    responded = false;
    isGuest = false;
  }

  void clearStats() {
    Map<String, dynamic> statsQ1 = {
      "firstMostPopular": "",
      "numResponsesFirst": 0,
      "secondMostPopular": "",
      "numResponsesSecond": 0,
      "thirdMostPopular": "",
      "numResponsesThird": 0,
      "friendResponses": [],
    };

    Map<String, dynamic> statsQ2 = {
      "firstMostPopular": "",
      "numResponsesFirst": 0,
      "secondMostPopular": "",
      "numResponsesSecond": 0,
      "thirdMostPopular": "",
      "numResponsesThird": 0,
      "friendResponses": [],
    };

    Map<String, dynamic> statsQ3 = {
      "firstMostPopular": "",
      "numResponsesFirst": 0,
      "secondMostPopular": "",
      "numResponsesSecond": 0,
      "thirdMostPopular": "",
      "numResponsesThird": 0,
      "friendResponses": [],
    };

    Map<String, dynamic> statsQ4 = {
      "firstMostPopular": "",
      "numResponsesFirst": 0,
      "secondMostPopular": "",
      "numResponsesSecond": 0,
      "thirdMostPopular": "",
      "numResponsesThird": 0,
      "friendResponses": [],
    };
    Map<String, dynamic> statsQ5 = {
      "firstMostPopular": "",
      "numResponsesFirst": 0,
      "secondMostPopular": "",
      "numResponsesSecond": 0,
      "thirdMostPopular": "",
      "numResponsesThird": 0,
      "friendResponses": [],
    };

    int totalResponses = 0;
    int id = -1;

    String categoryQ1 = "";
    String categoryQ2 = "";
    String categoryQ3 = "";
    String categoryQ4 = "";
    String categoryQ5 = "";

    String question1 = "";
    String question2 = "";
    String question3 = "";
    String question4 = "";
    String question5 = "";

    int numVerbatimQ1 = -1;
    int numVerbatimQ2 = -1;
    int numVerbatimQ3 = -1;
    int numVerbatimQ4 = -1;
    int numVerbatimQ5 = -1;

    Map<String, List<String>?> verbatasticUsers = {};
    String verbatimedWord = '';
    List<String>? verbatasticUsernames = [];
  }



   void updateStats(){
    
   }
}
