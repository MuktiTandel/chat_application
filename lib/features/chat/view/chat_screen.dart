import 'dart:io';

import 'package:chat_application/core/elements/custom_textformfield.dart';
import 'package:chat_application/core/elements/customcolor.dart';
import 'package:chat_application/core/elements/customtext.dart';
import 'package:chat_application/core/models/user_model.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:chat_application/features/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final controller = Get.put(ChatController());

  UserModel? userModel;

  Constance constance = Constance();

  @override
  void initState() {
    super.initState();

    userModel = Get.arguments;

    constance.Debug('User data => ${userModel!.toMap()}');
  }

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
                      icon: const Icon(Icons.arrow_back_rounded, color: CustomColor.primary,)
                  ),
                  SizedBox(width: 2.w,),
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12
                    ),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(20),
                        child: Image.file(File(userModel!.image), fit: BoxFit.fill,),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  CustomText(
                    text: userModel!.username,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: CustomTextformfield(
                    controller: controller.message,
                    border_radius: 15,
                    focusBorderColor: Colors.black26,
                    prefixWidget: InkWell(
                      onTap: (){},
                      child: Image.asset(Images.smile, scale: 22,),
                    ),
                    suffixWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: (){},
                          child: Image.asset(Images.attachment, height: 3.h, width: 6.w,),
                        ),
                        SizedBox(width: 2.w,),
                        InkWell(
                          onTap: (){},
                          child: Image.asset(Images.outline_camera, height: 3.h, width: 6.w,),
                        ),
                        SizedBox(width: 3.w,)
                      ],
                    ),
                  )),
              SizedBox(width: 2.w,),
              Container(
                height: 6.h,
                width: 12.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    CustomColor.primary.withOpacity(0.5),
                    CustomColor.primary
                  ])
                ),
                child: Center(
                  child: Image.asset(Images.microphone, height: 3.h, width: 6.w, color: Colors.white,),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
