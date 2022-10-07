import 'dart:convert';

import 'package:chat_application/core/controller/database_controller.dart';
import 'package:chat_application/core/controller/firebase_controller.dart';
import 'package:chat_application/core/models/user_model.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  final databaseController = Get.put(DatabaseController());

  final firebase_controller = Get.put(FirebaseController());

  Constance constance = Constance();

  RxBool IsUser = false.obs;

  final userlist = [];

  List<UserModel> userData = [];

  @override
  void onInit() {
    super.onInit();

    getData();

  }

  Future getData() async{

    final data = await databaseController.getUser();

    userlist.addAll(data);

    userlist.forEach((element) {

      UserModel userdata = UserModel.fromMap(element.data());

      userData.add(userdata);

      constance.Debug('user list => ${userdata.toMap()}');
    });

    if(userlist.isNotEmpty){
      IsUser(!IsUser.value);
    }

  }

}