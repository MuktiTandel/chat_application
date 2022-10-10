import 'package:chat_application/core/utils/firebase_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel{

  final String id;
  final String username;
  final String email;
  final String phonenumber;
  final String password;
  final String image;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phonenumber,
    required this.password,
    required this.image
  });

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'username' : username,
      'email' : email,
      'phonenumber' : phonenumber,
      'password' : password,
      'image' : image
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] ?? '',
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        phonenumber: map['phonenumber'] ?? '',
        password: map['password'] ?? '',
        image: map['image'] ?? ''
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot snapshot) {
    String id = "";
    String username = "";
    String email = "";
    String phonenumber = "";
    String password = "";
    String image = "";

    try {
      id = snapshot.get(FirebaseConstant.id);
      username = snapshot.get(FirebaseConstant.username);
      email = snapshot.get(FirebaseConstant.email);
      phonenumber = snapshot.get(FirebaseConstant.phonenumber);
      password = snapshot.get(FirebaseConstant.password);
      image = snapshot.get(FirebaseConstant.image);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return UserModel(
        id: snapshot.id,
      username: username,
      email: email,
      phonenumber: phonenumber,
      password: password,
      image: image
    );
  }

}