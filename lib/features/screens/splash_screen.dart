import 'package:chat_application/core/routes/app_routes.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds:  3), () {
      Get.offAllNamed(Routes.LOGIN);
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
