import 'dart:io';

import 'package:chat_application/core/elements/custom_textformfield.dart';
import 'package:chat_application/core/elements/customcolor.dart';
import 'package:chat_application/core/elements/customtext.dart';
import 'package:chat_application/core/models/user_model.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:chat_application/features/chat/controller/chat_controller.dart';
import 'package:chat_application/features/chat/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                        child: userModel!.image.isNotEmpty ? Image.network(userModel!.image, fit: BoxFit.fill,) : Image.asset(Images.user, fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  Expanded(
                    child: CustomText(
                      text: userModel!.username,
                      color: Colors.black,
                      fontsize: 15.sp,
                      fontWeight: FontWeight.w600,
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
              ),
              SizedBox(height: 2.h,),
              buildListMessage()
            ],
          ),
        ),
        bottomSheet: Padding(
          padding:  EdgeInsets.all(4.w),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: CustomTextformfield(
                        controller: controller.message,
                        Autofocus: true,
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
                        onchange: (val) {
                          if(val.isNotEmpty){
                          }
                        },
                      )),
                  SizedBox(width: 2.w,),
                  InkWell(
                    onTap: (){
                      controller.OnMessageSend(controller.message.text, Constance.text, userModel!.id);
                    },
                    child: Container(
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
                        child: Image.asset(Images.send, height: 3.h, width: 6.w, color: Colors.white,),
                      ),
                    ),
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
        child: controller.groupChatId.isEmpty ?
            StreamBuilder<QuerySnapshot>(
              stream: controller.getChatMessage(userModel!.id, controller.limit),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                    controller.listMessages = snapshot.data!.docs;
                    if(controller.listMessages.isNotEmpty){
                      return ListView.builder(
                        reverse: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          controller: controller.scrollController,
                          itemBuilder: (BuildContext context, int index){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildItem(index, snapshot.data!.docs[index]),
                                SizedBox(height: 1.h,)
                              ],
                            );
                          });
                    } else {
                      return const Center(
                        child: Text('No Messages....'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: CustomColor.primary,
                      ),
                    );
                  }
                }
            ) :
            const Center(child: CircularProgressIndicator(color: CustomColor.primary,),)
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    ChatModel chatModel = ChatModel.fromDocument(documentSnapshot!);
    constance.Debug('chat => ${chatModel.toMap()}');
    if(chatModel.idFrom == chatModel.idTo){
      return chatModel.type == Constance.text ?
          messageBubble(chatModel.content, EdgeInsets.only(right: 4.w), Colors.black12) :
          chatModel.type == Constance.images ?
              Container(
                margin: EdgeInsets.only(right:4.w, top: 1.h),
                child: chatImage(chatModel.content, (){}),
              ) : const SizedBox.shrink();
    }else {
      return chatModel.type == Constance.text ?
          messageBubble(chatModel.content, EdgeInsets.only(left: 4.w), CustomColor.primary.withOpacity(0.1)) :
          chatModel.type == Constance.images ?
              Container(
                margin: EdgeInsets.only(right: 4.w, top: 1.h),
                child: chatImage(chatModel.content, (){}),
              ) : SizedBox.shrink();
    }
  }

  Widget messageBubble(String chatContent, EdgeInsetsGeometry margin, Color color){
    return Container(
     padding: EdgeInsets.all(1.h),
      margin: margin,
      width: 70.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color
      ),
      child: Text(chatContent,
        style: TextStyle(fontSize: 2.h, color: Colors.black),
      ),
    );
  }

  Widget chatImage(String imageUrl, Function ontap){
    return OutlinedButton(
        onPressed: (){
          ontap();
        },
        child: Image.network(
            imageUrl,
          height: 10.h,
          width: 20.w,
          fit: BoxFit.cover,
        )
    );
  }
}
