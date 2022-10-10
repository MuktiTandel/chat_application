import 'package:chat_application/core/elements/customColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  RxBool IsObscure  = true.obs;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void showpassword() {
    IsObscure(!IsObscure.value);
  }

}