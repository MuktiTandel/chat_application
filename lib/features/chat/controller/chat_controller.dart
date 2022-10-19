import 'dart:io';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:chat_application/core/controller/firebase_controller.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:chat_application/core/utils/firebase_constant.dart';
import 'package:chat_application/features/chat/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart' as rx;

class ChatController extends GetxController {

  TextEditingController message = TextEditingController();

  SharedPreferences? prefs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  List<QueryDocumentSnapshot> listMessages = [];

  int limit = 20;
  final int limitIncrement = 20;
  String groupChatId = '';
  String currentUserId = '';

  File? imageFile;
  File? videoFile;
  bool isLoading = false;
  bool isStricker = false;
  String imageUrl = '';
  String videoUrl = '';
  String fileUrl = '';

  RxBool IsSend = false.obs;

  final firebase_controller = Get.put(FirebaseController());

  Constance constance = Constance();

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  Future initialAudio(String songUrl) async {
    
    final session = await AudioSession.instance;
    
    await session.configure(const AudioSessionConfiguration.speech());
    
    audioPlayer.playbackEventStream.listen((event) {},
      onError: (Object e, StackTrace stackTrace){
          if (kDebugMode) {
            print('A stream error occurred: $e');
          }
      });

    try {
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(songUrl)));
    } catch (e) {
      constance.Debug("Error loading audio source: $e");
    }
  }

  Stream<PositionData> get positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Future getCurrentUser() async {

    User? user = FirebaseAuth.instance.currentUser;

    currentUserId = user!.uid;

    update();

    constance.Debug('Current user => $currentUserId');
  }

  UploadTask uploadImage(File file, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(file);
    return uploadTask;
  }

  UploadTask uploadVideo(File file, String filename) {
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
    picFile = await picker.pickImage(source: ImageSource.camera);
    if(picFile != null){
      imageFile = File(picFile.path);
      if(imageFile != null){
        isLoading = true;
        update();
        uploadImageFile();
      }
    }
  }

  Future getImagefromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? picFile;
    picFile = await picker.pickImage(source: ImageSource.gallery);
    if(picFile != null){
      imageFile = File(picFile.path);
      if(imageFile != null){
        uploadImageFile();
      }
    }
  }

  Future getVideo() async {
    ImagePicker picker = ImagePicker();
    XFile? picFile;
    picFile = await picker.pickVideo(source: ImageSource.camera);
    if(picFile != null){
      videoFile = File(picFile.path);
      uploadVideoFile();
    }
  }

  void uploadImageFile() async {

    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = uploadImage(imageFile!, filename);
    try {
      TaskSnapshot taskSnapshot = await uploadTask;
      imageUrl = await taskSnapshot.ref.getDownloadURL();
      isLoading = false;
      OnMessageSend(imageUrl, Constance.images, currentUserId);
      update();
    } on FirebaseException catch (e) {
      isLoading = false;
      update();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void uploadVideoFile() async {

    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = uploadVideo(videoFile!, filename);
    try {
      TaskSnapshot taskSnapshot = await uploadTask;
      videoUrl = await taskSnapshot.ref.getDownloadURL();
      OnMessageSend(videoUrl, Constance.video, currentUserId);
      update();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void OnMessageSend(String content, int type, String peerid) {
    constance.Debug('group chat id => $groupChatId');
    constance.Debug('current user Id => $currentUserId');
    if(content.trim().isNotEmpty){
      message.clear();
      sendMessage(content, type, groupChatId, currentUserId, peerid);
    }
  }

  void messageSend() {
    IsSend(!IsSend.value);
    update();
  }

  bool isMessageRecived(int index) {
    if((index > 0 && listMessages[index - 1].get(FirebaseConstant.idFrom) == currentUserId) || index == 0){
      return true;
    }
    return false;
  }


  bool isMessageSend(int index) {
    if((index > 0 && listMessages[index - 1].get(FirebaseConstant.idFrom) != currentUserId) || index == 0){
      return true;
    }
    return false;
  }

  void readLocal(String id) {
    if(currentUserId.compareTo(id) > 0 ){
      groupChatId = '$currentUserId - $id';
      constance.Debug('Group chat id => $groupChatId');
    } else {
      groupChatId = '$id - $currentUserId';
      constance.Debug('Group id => $groupChatId');
    }

    updateData(FirebaseConstant.pathUserCollection, id, {
      FirebaseConstant.chattingWith : id
    });
  }

  Future UploadVideo() async {

    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + currentUserId);
      final String today = ('$month - $date');

      final file = await ImagePicker.platform.pickVideo(source: ImageSource.camera);

      if(file != null){
            videoFile = File(file.path);
          }

      Reference reference = FirebaseStorage.instance.ref().child('Video').child(today).child(storageId);
      UploadTask uploadTask = reference.putFile(videoFile!, SettableMetadata(contentType: 'video/mp4'));

      TaskSnapshot taskSnapshot = await uploadTask;
      videoUrl = await taskSnapshot.ref.getDownloadURL();
      OnMessageSend(videoUrl, Constance.video, currentUserId);
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future getPdfAndUpload() async {
    String filename = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    File? picFile;

    if(result != null){
      picFile = File(result.files.single.path!);
    }

    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(picFile!);

    try {
      TaskSnapshot taskSnapshot = await uploadTask;
      fileUrl = await taskSnapshot.ref.getDownloadURL();
      isLoading = false;
      OnMessageSend(fileUrl, Constance.file, currentUserId);
      update();
    } on FirebaseException catch (e) {
      isLoading = false;
      update();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future getAudioAndUpload() async {
    File? audioFile;

    String filename = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    String audiofile = '';

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio
    );

    if(result != null) {
      audioFile = File(result.files.single.path!);
    }

    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(audioFile!);

    try {
      TaskSnapshot taskSnapshot = await uploadTask;
      audiofile = await taskSnapshot.ref.getDownloadURL();
      OnMessageSend(audiofile, Constance.audio, currentUserId);
      update();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }


  }

}