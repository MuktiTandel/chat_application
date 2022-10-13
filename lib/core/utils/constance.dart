import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Constance {

  void Debug(String message){
    if(kDebugMode){
      print("***** ${message} *****");
    }
  }

  void  showSnack(String title, String message) {
    Get.snackbar(title, message);
  }

  static const int text = 0;
  static const int images = 1;
  static const int sticker = 2;
  static const int video = 3;

}