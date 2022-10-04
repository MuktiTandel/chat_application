import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {

  TextEditingController otp = TextEditingController();
  String completeNumber = '';

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    otp.dispose();
    super.dispose();
  }
}