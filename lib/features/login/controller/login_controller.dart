import 'package:chat_application/core/elements/customColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Color btn_color = CustomColor.disable_btn;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void changeColor(bool Isenable){
    if(Isenable == true){
      btn_color = CustomColor.primary;
      update();
    }else{
      btn_color = CustomColor.disable_btn;
    }
  }

}