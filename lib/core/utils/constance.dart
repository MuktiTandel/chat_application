import 'package:flutter/foundation.dart';

class Constance {

  void Debug(String message){
    if(kDebugMode){
      print("***** ${message} *****");
    }
  }
}