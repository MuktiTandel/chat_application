import 'package:chat_application/core/models/user_model.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {

  final storage = FirebaseStorage.instance;

  final storageRef = FirebaseStorage.instance.ref().child('User');

  FirebaseDatabase database = FirebaseDatabase.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Constance constance = Constance();

  Future getUser() async{

    var snapshot = await users.orderBy('id').limit(10).get();

    return snapshot.docs;
  }

}