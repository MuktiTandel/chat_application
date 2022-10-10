import 'dart:io';

import 'package:chat_application/features/chat/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {

  TextEditingController message = TextEditingController();

  SharedPreferences? prefs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  List<QueryDocumentSnapshot> listMessages = [];

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';
  String currentUserId = '';

  File? imageFile;
  bool isLoading = false;
  bool isStricker = false;
  String imageUrl = '';

  final ScrollController scrollController = ScrollController();

  _scrollListner() {
    if(scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange){
      _limit += _limitIncrement;
      update();
    }
  }

  UploadTask uploadImage(File file, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(file);
    return uploadTask;
  }

  Future<void> updateData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate){
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit){
    return firebaseFirestore
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timeStemp', descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendMessage(String content, int type, String GroupChatId, String CurrentUserId, String PeerId){

    DocumentReference documentReference = firebaseFirestore
        .collection('messages')
        .doc(GroupChatId)
        .collection(GroupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatModel chatModel = ChatModel(
        content: content,
        idFrom: CurrentUserId,
        idTo: PeerId,
        timeStemp: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type
    );

    FirebaseFirestore.instance.runTransaction((transaction) async{
      transaction.set(documentReference, chatModel.toMap());
    });
  }

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    XFile? picFile;
    picFile = await picker.pickImage(source: ImageSource.gallery);
    if(picFile != null){
      imageFile = File(picFile.path);
      if(imageFile != null){
        isLoading = true;
        update();
      }
    }
  }

  void uploadImageFile() async {

    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = uploadImage(imageFile!, filename);
    try {
      TaskSnapshot taskSnapshot = await uploadTask;
      imageUrl = await taskSnapshot.ref.getDownloadURL();
      isLoading = false;
      update();
    } on FirebaseException catch (e) {
      isLoading = false;
      update();
      print(e);
    }
  }

  void OnMessageSend(String content, int type, String peerid) {
    if(content.trim().isNotEmpty){
      message.clear();
      sendMessage(content, type, groupChatId, currentUserId, peerid);
    }
  }

}