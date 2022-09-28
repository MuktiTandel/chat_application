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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(4.w),
        child: Center(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTitle(title: 'Sign in to your account'),
                SizedBox(height: 5.h,),
                CustomTextformfield(
                    controller: controller.email,
                  hinttext: 'Enter Email',
                  prefixicon: Icons.email_rounded,
                  border_radius: 35,
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
                SizedBox(height: 2.5.h,),
                CustomTextformfield(
                    controller: controller.password,
                  prefixicon: Icons.lock,
                  hinttext: 'Enter Password',
                  border_radius: 35,
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
                  onchange: (val){
                      if(val.isNotEmpty){
                        controller.changeColor(true);
                      }
                  },
                ),
                SizedBox(height: 3.h,),
                CustomButton(
                    ontap: () async{
                      if(controller.formKey.currentState!.validate()){
                        FocusScope.of(context).unfocus();

                        // bool status = await  UserController().loginWithEmailPassword(
                        //     emailController.text, passwordController.text);
                        //
                        // if(!status){
                        //   utils.CustomSnackBar("Something Went Wrong", context);
                        // }else{
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
                        // }
                      }
                    },
                    buttontext: 'Sign In',
                  backgroundColor: controller.btn_color,
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
                        (){},
                      Images.google
                    ),
                    SizedBox(width: 10.w,),
                    loginButton((){}, Images.facebook)
                  ],
                )
              ],
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
