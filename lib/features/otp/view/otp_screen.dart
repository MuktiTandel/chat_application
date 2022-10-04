import 'package:chat_application/core/controller/firebase_controller.dart';
import 'package:chat_application/core/elements/customColor.dart';
import 'package:chat_application/core/elements/custombutton.dart';
import 'package:chat_application/core/elements/customtext.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:chat_application/features/otp/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
   OtpScreen({Key? key}) : super(key: key);

  final defaultPinTheme = PinTheme(
    width: 15.w,
    height: 7.h,
    textStyle: TextStyle(
      fontSize: 15.sp
    ),
    decoration: BoxDecoration(
      border: Border.all(color: CustomColor.primary),
      borderRadius: BorderRadius.circular(20)
    )
  );

  final firebase_controller = Get.put(FirebaseController());

  final controller = Get.put(OtpController());

  Constance constance = Constance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(6.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){
                    Get.back();
                  }, icon: Icon(Icons.arrow_back_rounded, color: CustomColor.primary, size: 4.h,)),
                  SizedBox(width: 5.w,),
                  CustomText(
                      text: 'Enter OTP Code',
                    fontWeight: FontWeight.bold,
                    fontsize: 15.sp,
                  ),
                ],
              ),
              Container(
                child: Column(
                  children: [
                    CustomText(text: 'code has been send to phone number'),
                    SizedBox(height: 5.h,),
                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      keyboardType: TextInputType.number,
                      controller: controller.otp,
                    )
                  ],
                ),
              ),
              CustomButton(
                  ontap: () async{
                    if(controller.otp.text.isNotEmpty){
                      await firebase_controller.verifyOTP(controller.otp.text);
                    }else {
                      constance.showSnack('Warning!', 'Please Enter OTP');
                    }
                  },
                  buttontext: 'Verify',
                backgroundColor: CustomColor.primary,
                borderRadius: 35,
              )
            ],
          ),
        ),
      ),
    );
  }
}
