class GameObject {
  String responseQ1;
  String responseQ2;
  String responseQ3;
  String referer;
  // String responseQ4;
  // String responseQ5;

  GameObject(this.responseQ1, this.responseQ2, this.responseQ3, this.referer
      );


  bool isEmpty(){
    return responseQ1== '' && responseQ2== ''&& responseQ3 == '';
  }

  bool hasReferer(){
    return referer != '';
  }
}
