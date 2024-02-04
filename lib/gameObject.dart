import 'package:flutter/foundation.dart';

class GameObject extends ChangeNotifier{
  String responseQ1 = '';
  String responseQ2 = '';
  String responseQ3 = '';
  String referer = '';
  // String responseQ4;
  // String responseQ5;

  // GameObject(this.responseQ1, this.responseQ2, this.responseQ3, this.referer
  //     );

   //GameObject get obj => obj;
  bool isEmpty(){
    return responseQ1== '' && responseQ2== ''&& responseQ3 == '';
  }

  bool hasReferer(){
    return referer != '';
  }

  void updateValues(String response1, String response2, String response3)async {
    responseQ1 = response1;
    responseQ2 = response2;
    responseQ3 = response3;
    // this.responseQ4 = response;
    // this.responseQ5 = response;
    print("In update of game object" + response1);
   
    notifyListeners(); 
  }

  void setReferer(String referer)async{
    this.referer = referer;
    notifyListeners(); 

  }
}

