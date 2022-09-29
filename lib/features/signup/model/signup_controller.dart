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

  RxBool IsObsecure1 = true.obs;

  RxBool IsObsecure2 = true.obs;

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phoneNumber.dispose();
    password.dispose();
    confPassword.dispose();
    super.dispose();
  }

  void showpassword1(){
    IsObsecure1(!IsObsecure1.value);
  }

  void showpassword2(){
    IsObsecure2(!IsObsecure2.value);
  }


}