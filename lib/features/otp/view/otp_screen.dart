import 'package:chat_application/core/elements/customColor.dart';
import 'package:chat_application/core/elements/custom_textformfield.dart';
import 'package:chat_application/core/elements/custom_title.dart';
import 'package:chat_application/core/elements/customtext.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(4.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_rounded, color: CustomColor.primary, size: 4.h,)),
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
                      disabledPinTheme: PinTheme(
                        decoration: BoxDecoration(
                          border: Border.all(color: CustomColor.primary)
                        )
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
