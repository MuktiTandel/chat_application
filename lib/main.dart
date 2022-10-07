import 'package:chat_application/core/controller/firebase_controller.dart';
import 'package:chat_application/core/localization/translation_service.dart';
import 'package:chat_application/core/routes/app_pages.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/features/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) {
    Get.put(FirebaseController());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType){
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: TranslationService.locale,
          fallbackLocale: TranslationService.fallbackLocale,
          translations: TranslationService(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          home: SplashScreen(),
        );
      },
    );
  }
}

