import 'package:chat_application/core/controller/firebase_controller.dart';
import 'package:chat_application/core/elements/customColor.dart';
import 'package:chat_application/core/elements/custom_richtext.dart';
import 'package:chat_application/core/elements/custom_textformfield.dart';
import 'package:chat_application/core/elements/custom_title.dart';
import 'package:chat_application/core/elements/custombutton.dart';
import 'package:chat_application/core/routes/app_routes.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:chat_application/features/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);

  final controller = Get.put(LoginController());

  final firebase_controller = Get.put(FirebaseController());

   final formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(4.w),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTitle(title: 'Sign in to your account'),
                  SizedBox(height: 5.h,),
                  CustomTextformfield(
                    controller: controller.email,
                    hinttext: 'Enter Email',
                    prefixWidget: const Icon(Icons.email_rounded, color: CustomColor.primary,),
                    focusBorderColor: CustomColor.primary,
                    cursorColor: CustomColor.primary,
                    border_radius: 35,
                    onchange: (val){},
                    validator: (val){
                      String pattern =
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?)*$";
                      RegExp regex = RegExp(pattern);
                      if (val == null || val.isEmpty || !regex.hasMatch(val)) {
                        return 'Enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 2.5.h,),
                  Obx(() => CustomTextformfield(
                    controller: controller.password,
                    hinttext: 'Enter Password',
                    cursorColor: CustomColor.primary,
                    border_radius: 35,
                    isObscure: controller.IsObscure.value,
                    prefixWidget: const Icon(Icons.lock, color: CustomColor.primary,),
                    focusBorderColor: CustomColor.primary,
                    maxline: 1,
                    onchange: (val){},
                    suffixWidget: IconButton(
                        onPressed: (){
                          controller.showpassword();
                        },
                        icon: const Icon(Icons.remove_red_eye_rounded, color: Colors.black26,)
                    ),
                    validator: (val){
                      RegExp regex =
                      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
                      if (val.isEmpty) {
                        return 'Please enter password';
                      } else {
                        if (!regex.hasMatch(val)) {
                          return 'Enter valid password';
                        } else {
                          return null;
                        }
                      }
                    },
                  ),),
                  SizedBox(height: 3.h,),
                  CustomButton(
                    ontap: () async{
                      if(formKey1.currentState!.validate()){
                        FocusScope.of(context).unfocus();

                        firebase_controller.login(controller.email.text, controller.password.text);

                      }
                    },
                    buttontext: 'Sign In',
                    backgroundColor: CustomColor.primary,
                    borderRadius: 30,
                  ),
                  SizedBox(height: 4.h,),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.SIGNUP);
                    },
                    child: const CustomRichtext(
                      childtext: 'Sign up',
                      title: "Don't have an account? ",
                    ),
                  ),
                  SizedBox(height: 5.h,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black45,
                              thickness: 0.1.h,
                            )),
                      ),
                      Text("Or",
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12.sp
                        ),),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black45,
                              thickness: 0.1.h,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loginButton(
                              (){
                                firebase_controller.signInWithGoogle();
                              },
                          Images.google
                      ),
                      SizedBox(width: 10.w,),
                      loginButton((){
                        firebase_controller.signInWithFacebook();
                      }, Images.facebook)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(Function ontap, String icon){
    return InkWell(
      onTap: (){
        ontap();
      },
      child: Container(
        height: 7.h,
        width: 14.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Image.asset(icon, height: 5.h,),
        ),
      ),
    );
  }
}
