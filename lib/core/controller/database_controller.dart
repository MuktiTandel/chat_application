import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class DatabaseController extends GetxController {

  final storage = FirebaseStorage.instance;

  final storageRef = FirebaseStorage.instance.ref().child('User');

  FirebaseDatabase database = FirebaseDatabase.instance;

}