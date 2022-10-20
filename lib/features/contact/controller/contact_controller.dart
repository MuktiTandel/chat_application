import 'dart:io';

import 'package:chat_application/core/models/contact_model.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:chat_application/features/chat/controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {

  Constance constance = Constance();

  List<ContactModel> contacts_data = [];

  RxBool IsList = false.obs;

  Uint8List? thumbnail;

  final chat_controller = Get.put(ChatController());

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String imageUrl = '';

  @override
  void onInit() {
   super.onInit();
    getContact();
  }


  Future getContact() async {

    final contacts = await FastContacts.allContacts;
    constance.Debug('${contacts.first.structuredName?.familyName}');

    contacts.forEach((element) {
      ContactModel data = ContactModel(
          id: element.id,
          displayname: element.displayName,
          emails: element.emails,
          phones: element.phones
      );

      constance.Debug('${data.toMap()}');

      contacts_data.add(data);

      if(contacts_data.isNotEmpty){
        IsList.value = true;
      }

      update();

    });

  }

  Future getImage(String id) async {
    thumbnail =  await FastContacts.getContactImage(id);
    constance.Debug('$thumbnail');
    update();
    if(thumbnail!.isNotEmpty){
       uploadImageFile(File.fromRawPath(thumbnail!));
    }
  }

  Future senddata(String content) async {
    chat_controller.OnMessageSend(content, Constance.contact, chat_controller.currentUserId);
  }

  UploadTask uploadImage(File file, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(file);
    return uploadTask;
  }

  Future uploadImageFile(File file) async {

    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = uploadImage(file, filename);

    try {
      TaskSnapshot taskSnapshot = await uploadTask;
      imageUrl = await taskSnapshot.ref.getDownloadURL();
      constance.Debug('$imageUrl');
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

}