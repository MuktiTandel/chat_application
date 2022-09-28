import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController{

  TextEditingController username = TextEditingController();
  File image = File('path');
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phoneNumber.dispose();
    password.dispose();
    confPassword.dispose();
    super.dispose();
  }

}