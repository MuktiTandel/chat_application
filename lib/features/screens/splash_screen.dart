import 'package:chat_application/core/controller/firebase_controller.dart';
import 'package:chat_application/core/routes/app_routes.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final controller = Get.put(FirebaseController());

  @override
  void initState() {
    super.initState();
    getpage();
  }

  Future getpage() async {

    User? user = await FirebaseAuth.instance.currentUser;

    Future.delayed(Duration(seconds: 3), (){
      if(user == null){
        Get.offAllNamed(Routes.LOGIN);
      }else{
        Get.offAllNamed(Routes.HOME);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Images.Applogo), scale: 4)
        ),
      ),
    );
  }
}
