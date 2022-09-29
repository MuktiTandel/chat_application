import 'package:chat_application/core/controller/firebase_controller.dart';
import 'package:chat_application/core/elements/customColor.dart';
import 'package:chat_application/core/elements/custom_richtext.dart';
import 'package:chat_application/core/elements/custom_textformfield.dart';
import 'package:chat_application/core/elements/custom_title.dart';
import 'package:chat_application/core/elements/custombutton.dart';
import 'package:chat_application/core/elements/customdialog.dart';
import 'package:chat_application/core/elements/customtext.dart';
import 'package:chat_application/core/routes/app_routes.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:chat_application/features/signup/model/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupScreen extends StatelessWidget {
   SignupScreen({Key? key}) : super(key: key);

   final controller = Get.put(SignupController());

   final firebase_controller = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(4.w),
            child: Form(
              key: controller.formKey,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const CustomTitle(title: 'Sign up'),
                SizedBox(height: 4.h,),
                SizedBox(
                  height: 17.h,
                  width: 35.w,
                  child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Colors.black12,
                              shape: BoxShape.circle
                          ),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(60),
                              child: Image.asset(Images.user, fit: BoxFit.fill,),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 11.h,
                          left: 22.w,
                          child: GestureDetector(
                            onTap: (){
                              showDialog(context: context, builder: (context){
                                return CustomDialog(
                                  title: 'Select Image',
                                  content: Padding(
                                    padding: EdgeInsets.zero,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Divider(thickness: 1, color: Colors.black38,),
                                        SizedBox(height: 1.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ContentWidget((){
                                              Get.back();
                                            }, Images.photo_camera, 'Camera'),
                                            SizedBox(width: 8.w,),
                                            ContentWidget((){
                                              Get.back();
                                            }, Images.gallery, 'Gallery')
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: CustomColor.primary, width: 2)
                                ),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(20),
                                    child: Image.asset(Images.photo_camera, scale: 19, color: CustomColor.primary,),
                                  ),
                                )
                            ),
                          ),
                        )
                      ]
                  ),
                ),
                SizedBox(height: 3.h,),
                CustomTextformfield(
                  controller: controller.username,
                  prefixicon: Icons.person,
                  hinttext: 'Enter username',
                  border_radius: 35,
                  prefixiconColor: CustomColor.primary,
                  focusBorderColor: CustomColor.primary,
                  cursorColor: CustomColor.primary,
                  validator: (val){
                    if(val == null || val.isEmpty){
                      return 'Enter a valid user name';
                    }else{
                      if(val.length < 4){
                        return 'Username must be at least 4 characters';
                      }else{
                        return null;
                      }
                    }
                  },
                ),
                SizedBox(height: 2.h,),
                CustomTextformfield(
                  controller: controller.email,
                  prefixicon:  Icons.email_rounded,
                  hinttext: 'Enter email',
                  border_radius: 35,
                  prefixiconColor: CustomColor.primary,
                  focusBorderColor: CustomColor.primary,
                  cursorColor: CustomColor.primary,
                  validator: (val){
                    String pattern =
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?)*$";
                    RegExp regex = RegExp(pattern);
                    if (val == null || val.isEmpty || !regex.hasMatch(val))
                      return 'Enter a valid email address';
                    else
                      return null;
                  },
                ),
                SizedBox(height: 2.h,),
                IntlPhoneField(
                  disableLengthCheck: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                          borderSide: BorderSide(color: CustomColor.primary)
                      )
                  ),
                  controller: controller.phoneNumber,
                  cursorColor: CustomColor.primary,
                  initialCountryCode: 'IN',
                  validator: (val){},
                ),
                SizedBox(height: 2.h,),
                Obx(() =>  CustomTextformfield(
                  controller: controller.password,
                  border_radius: 35,
                  prefixicon: Icons.lock,
                  hinttext: 'Enter password',
                  prefixiconColor: CustomColor.primary,
                  focusBorderColor: CustomColor.primary,
                  isObscure: controller.IsObsecure1.value,
                  cursorColor: CustomColor.primary,
                  suffixWidget: IconButton(
                      onPressed: (){
                        controller.showpassword1();
                      },
                      icon: Icon(Icons.remove_red_eye_rounded, color: Colors.black26,)
                  ),
                  validator: (val){
                    RegExp regex =
                    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
                    if (val.isEmpty) {
                      return 'Please enter password';
                    } else {
                      if (!regex.hasMatch(val)) {
                        return 'Enter valid password';
                      }  else {
                        return null;
                      }
                    }
                  },
                ),
                ),
                SizedBox(height: 2.h,),
                Obx(() => CustomTextformfield(
                  controller: controller.confPassword,
                  border_radius: 35,
                  prefixicon: Icons.lock,
                  hinttext: 'Enter confirm password',
                  prefixiconColor: CustomColor.primary,
                  focusBorderColor: CustomColor.primary,
                  isObscure: controller.IsObsecure2.value,
                  cursorColor: CustomColor.primary,
                  suffixWidget: IconButton(
                      onPressed: (){
                        controller.showpassword2();
                      },
                      icon: Icon(Icons.remove_red_eye_rounded, color: Colors.black26,)
                  ),
                  validator: (val){
                    RegExp regex =
                    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
                    if (val.isEmpty) {
                      return 'Please enter password';
                    } else {
                      if (!regex.hasMatch(val)) {
                        return 'Enter valid password';
                      } else if(val != controller.password.text){
                        return 'Password does not match';
                      }else {
                        return null;
                      }
                    }
                  },
                )),
                SizedBox(height: 3.h,),
                CustomButton(
                  ontap: () async{
                    /*if(controller.formKey.currentState!.validate()){
                      FocusScope.of(context).unfocus();

                      firebase_controller.register(controller.email.text, controller.password.text);
                    }*/
                    Get.offAllNamed(Routes.OTP);
                  },
                  buttontext: 'Sign up',
                  borderRadius: 35,
                  backgroundColor: CustomColor.primary,
                ),
                SizedBox(height: 4.h,),
                GestureDetector(
                    onTap: (){
                      Get.offAllNamed(Routes.LOGIN);
                    },
                    child: const CustomRichtext(childtext: 'Sign in', title: 'Already have account? ')
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget ContentWidget(Function ontap, String icon, String icon_name){
    return GestureDetector(
      onTap: (){
        ontap();
      },
      child: Column(
        children: [
          Container(
            height: 9.h,
            width: 19.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: CustomColor.primary.withOpacity(0.2),
                border: Border.all(color: CustomColor.primary, width: 2)
            ),
            child: Image.asset(icon, scale: 13, color: CustomColor.primary,),
          ),
          SizedBox(height: 1.h,),
          CustomText(text: icon_name)
        ],
      ),
    );
  }
}
