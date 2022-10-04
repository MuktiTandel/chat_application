import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {

  TextEditingController otp = TextEditingController();
  String completeNumber = '';

  @override
  void dispose() {
    otp.dispose();
    super.dispose();
  }
}