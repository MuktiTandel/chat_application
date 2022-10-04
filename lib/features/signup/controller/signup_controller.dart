import 'dart:io';

import 'package:chat_application/core/models/user_model.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignupController extends GetxController{

  TextEditingController username = TextEditingController();
  File image = File('path');
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  String complete_number = '';

  final formKey = GlobalKey<FormState>();

  RxBool IsObsecure1 = true.obs;

  RxBool IsObsecure2 = true.obs;

  RxBool IsImage = false.obs;

  final ImagePicker picker = ImagePicker();

  XFile? picImage;

  Constance constance = Constance();

  UserModel? userdata;

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

  void checkImage() {

    if(picImage!.path.isNotEmpty){
      IsImage(!IsImage.value);
      image = File(picImage!.path);
    }else {
      constance.Debug("pic image is empty");
    }
  }




}