import 'package:chat_application/core/routes/app_routes.dart';
import 'package:chat_application/features/login/view/login_screen.dart';
import 'package:chat_application/features/screens/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: Routes.LOGIN, page: ()=> LoginScreen()),
    GetPage(name: Routes.SPLASH, page: ()=> SplashScreen())
  ];
}