
import 'package:chat_application/core/controller/database_controller.dart';
import 'package:chat_application/core/controller/firebase_controller.dart';
import 'package:chat_application/core/models/user_model.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:chat_application/core/utils/firebase_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  final databaseController = Get.put(DatabaseController());

  final firebase_controller = Get.put(FirebaseController());

  Constance constance = Constance();

  RxBool IsUser = false.obs;

  final userlist = [];

  List<UserModel> userData = [];

   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController search = TextEditingController();

  late String currentUserId;

  @override
  void onInit() {
    super.onInit();

     // getData();

    getCurrentUser();

  }

  Future getCurrentUser() async {

    User? user = await FirebaseAuth.instance.currentUser;

    currentUserId = user!.uid;

    update();

    constance.Debug('Current user => ${currentUserId}');
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
  
  Stream<QuerySnapshot> getFireStoreData(
      String collectionPath, int limit, String? textSearch) {
    if(textSearch?.isNotEmpty == true){
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .where(FirebaseConstant.username, isEqualTo: textSearch)
          .snapshots();
    }else {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .snapshots();
    }
  }

}