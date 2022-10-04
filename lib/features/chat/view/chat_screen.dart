import 'package:chat_application/core/elements/custom_textformfield.dart';
import 'package:chat_application/core/elements/customcolor.dart';
import 'package:chat_application/core/elements/customtext.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:chat_application/features/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
   ChatScreen({Key? key}) : super(key: key);

  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: (){
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_rounded, color: CustomColor.primary,)
                  ),
                  SizedBox(width: 2.w,),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12
                    ),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(20),
                        child: Image.asset(Images.user),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  CustomText(
                    text: 'text',
                    color: Colors.black,
                    fontsize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  Expanded(child: SizedBox(width: 2.w,)),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      height: 6.h,
                      width: 12.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CustomColor.primary.withOpacity(0.1)
                      ),
                      child: Image.asset(Images.call, scale: 19, color: CustomColor.primary,),
                    ),
                  ),
                  SizedBox(width: 2.w,),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      height: 6.h,
                      width: 12.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CustomColor.primary.withOpacity(0.1)
                      ),
                      child: Image.asset(Images.video, scale: 19, color: CustomColor.primary,),
                    ),
                  ),
                  SizedBox(width: 2.w,),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      height: 6.h,
                      width: 12.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomColor.primary.withOpacity(0.1)
                      ),
                      child: Image.asset(Images.menu, scale: 19, color: CustomColor.primary,),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        bottomSheet: Padding(
          padding:  EdgeInsets.all(4.w),
          child: Row(
            children: [
              Expanded(
                  child: SizedBox(
                    height: 6.h,
                    child: CustomTextformfield(
                        controller: controller.message,
                      border_radius: 15,
                      focusBorderColor: Colors.black26,
                      prefixWidget: InkWell(
                        onTap: (){},
                        child: Image.asset(Images.smile, scale: 22,),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
