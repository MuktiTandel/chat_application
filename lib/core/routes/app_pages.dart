import 'package:chat_application/core/routes/app_routes.dart';
import 'package:chat_application/features/home/view/home_screen.dart';
import 'package:chat_application/features/login/view/login_screen.dart';
import 'package:chat_application/features/otp/view/otp_screen.dart';
import 'package:chat_application/features/screens/splash_screen.dart';
import 'package:chat_application/features/signup/view/signup_screen.dart';
import 'package:get/get.dart';

class AppPages {

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: Routes.LOGIN, page: ()=> LoginScreen()),
    GetPage(name: Routes.SPLASH, page: ()=> SplashScreen()),
    GetPage(name: Routes.SIGNUP, page: ()=> SignupScreen()),
    GetPage(name: Routes.HOME, page: ()=> HomeScreen()),
    GetPage(name: Routes.OTP, page: ()=> OtpScreen())
  ];

}