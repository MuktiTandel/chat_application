import 'dart:convert';

import 'package:chat_application/core/elements/control_button.dart';
import 'package:chat_application/core/elements/custom_textformfield.dart';
import 'package:chat_application/core/elements/customcolor.dart';
import 'package:chat_application/core/elements/customtext.dart';
import 'package:chat_application/core/elements/seekbar.dart';
import 'package:chat_application/core/models/contact_model.dart';
import 'package:chat_application/core/models/user_model.dart';
import 'package:chat_application/core/routes/app_routes.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:chat_application/features/chat/controller/chat_controller.dart';
import 'package:chat_application/features/chat/model/chat_model.dart';
import 'package:chat_application/features/chat/view/pdf_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final controller = Get.put(ChatController());

  UserModel? userModel;

  Constance constance = Constance();

  final ScrollController scrollController = ScrollController();

  VideoPlayerController? videoPlayerController;

  bool IsMessage = false;

  @override
  void initState() {
    super.initState();

    userModel = Get.arguments;

    constance.Debug('User data => ${userModel!.toMap()}');

    controller.getCurrentUser();

    controller.readLocal(userModel!.id);

    scrollController.addListener(() {
      if(scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange){
        controller.limit += controller.limitIncrement;
        setState(() {
        });
      }
    });
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    buildListMessage(),
                    SizedBox(height: 2.h,),
                    buildMessageView(context)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageView(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (Controller) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: CustomTextformfield(
                  controller: controller.message,
                  Autofocus: false,
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
                        onTap: (){
                          // controller.UploadVideo();
                          showGeneralDialog(context: context,
                              barrierColor: Colors.transparent,
                              pageBuilder: (context, anim1, anim2){
                            return showBottomDialog();
                          });
                        },
                        child: Image.asset(Images.attachment, height: 3.h, width: 6.w,),
                      ),
                      SizedBox(width: 2.w,),
                      InkWell(
                        onTap: (){
                          controller.getImage();
                        },
                        child: Image.asset(Images.outline_camera, height: 3.h, width: 6.w,),
                      ),
                      SizedBox(width: 3.w,)
                    ],
                  ),
                  onchange: (val) {
                    if(val.isNotEmpty || val != null){
                      IsMessage = true;
                    }else if(val.isEmpty || val == null){
                      IsMessage = false;
                    }
                    setState(() {

                    });
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
                  child: Image.asset(IsMessage ? Images.send : Images.microphone, height: 3.h, width: 6.w, color: Colors.white,),
                ),
              ),
            )
          ],
        );
      }
    );
  }

  Widget buildListMessage() {
    return Flexible(
        child: controller.groupChatId.isNotEmpty ?
            StreamBuilder<QuerySnapshot>(
              stream: controller.getChatMessage(controller.groupChatId, controller.limit),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasData){
                    controller.listMessages = snapshot.data!.docs;
                    if(controller.listMessages.isNotEmpty){
                      return ListView.builder(
                        reverse: true,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          controller: scrollController,
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
    if(documentSnapshot != null){
      ChatModel chatModel = ChatModel.fromDocument(documentSnapshot);
      String date = chatModel.timeStemp;
      final f = DateFormat('HH:mm');
      String time = f.format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)));
      if(chatModel.idFrom == controller.currentUserId){
        if(chatModel.type == Constance.text) {
          return messageBubble(chatModel.content, EdgeInsets.only(right: 4.w), CustomColor.message_bubble, time);
        } else if( chatModel.type == Constance.images) {
          return Container(
            margin: EdgeInsets.only(top: 1.h),
            child: chatImage(chatModel.content, CustomColor.message_bubble, time),
          );
        } else if ( chatModel.type == Constance.video ){
          return Container(
            margin: EdgeInsets.only(top: 1.h),
            child: chatVideo(chatModel.content, time, CustomColor.message_bubble),
          );
        } else if ( chatModel.type == Constance.file) {
          return chatFile(chatModel.content, time, CustomColor.message_bubble);
        } else if ( chatModel.type == Constance.audio) {
          return chatAudio(chatModel.content, time, CustomColor.message_bubble);
        } else if( chatModel.type == Constance.contact) {
          final data = jsonDecode(chatModel.content);
          ContactDetail contactDetail = ContactDetail(
              displayname: data['displayname'],
              id: data['id'],
              image: data['image'],
              email: data['email'],
              phone: data['phone']
          );
           constance.Debug('$data');
          return Container(
            height: 9.h,
            width: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: CustomColor.message_bubble
            ),
            child: Row(
              children: [
                Container(
                  height: 6.5.h,
                  width: 13.w,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.memory(contactDetail.image, fit: BoxFit.fill,))
                )
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
      else {
        if( chatModel.type == Constance.text ) {
          return messageBubble(chatModel.content, EdgeInsets.only(left: 20.w), CustomColor.primary.withOpacity(0.1), time);
        } else if ( chatModel.type == Constance.images ) {
          return  Container(
            margin: const EdgeInsets.only(left: 190),
            child: chatImage(chatModel.content, CustomColor.primary.withOpacity(0.5), time),
          );
        } else if ( chatModel.type == Constance.video) {
          return Container(
            margin: EdgeInsets.only(top: 1.h),
            child: chatVideo(chatModel.content, time, CustomColor.primary.withOpacity(0.5)),
          );
        } else if (chatModel.type == Constance.file) {
          return Align(
            alignment: Alignment.topRight,
              child: chatFile(chatModel.content, time, CustomColor.primary.withOpacity(0.5)));
        } else if ( chatModel.type == Constance.audio ) {
          return Align(
            alignment: Alignment.topRight,
            child: chatAudio(chatModel.content, time, CustomColor.primary.withOpacity(0.5)),
          );
        }else {
          return const SizedBox.shrink();
        }
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget messageBubble(String chatContent, EdgeInsetsGeometry margin, Color color, String time){
    return Container(
     padding: EdgeInsets.all(1.5.h),
      margin: margin,
      width: 70.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(chatContent,
            style: TextStyle(fontSize: 2.h, color: Colors.black),
          ),
          Text(time,
            style: TextStyle(fontSize: 1.3.h, color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget chatImage(String imageUrl, Color color, String time){
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              imageUrl,
            height: 20.h,
            width: 40.w,
            fit: BoxFit.fill,
          ),
        ),
          Container(
            margin: EdgeInsets.only(right: 2.w, bottom: 1.h),
              child: Text(time,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 1.5.h,
                  fontWeight: FontWeight.w600
                ),
              )
          )
    ]
      ),
    );
  }

  Widget chatVideo(String videoUrl, String time, Color color){
    constance.Debug('Video Url => $videoUrl}');
    videoPlayerController = VideoPlayerController.network(videoUrl)..initialize().then((value) {
      setState(() {
          videoPlayerController!.play();
      });
    } );
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(videoPlayerController!),
              )
            ),
            Container(
                margin: EdgeInsets.only(right: 2.w, bottom: 1.h),
                child: Text(time,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 1.5.h,
                      fontWeight: FontWeight.w600
                  ),
                )
            )
          ]
      ),
    );
  }

  Widget showBottomDialog() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 30.h,
        margin: const EdgeInsets.only(bottom: 80, left: 12, right: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12,width: 0.5.w)
        ),
        child: GridView.count(
            crossAxisCount: 3,
          padding: EdgeInsets.only(top: 1.h),
          physics: const NeverScrollableScrollPhysics(),
          children: [
           dialogItem((){
             controller.getPdfAndUpload();
           }, Images.document, 'Document'),
           dialogItem((){
             controller.getImage();
           }, Images.outline_camera, 'Camera'),
           dialogItem((){
             controller.getImagefromGallery();
           }, Images.outline_gallery, 'Gallery'),
           dialogItem((){
             controller.getAudioAndUpload();
           }, Images.audio, 'Audio'),
           dialogItem((){}, Images.location, 'Location'),
           dialogItem(() async{
             Get.toNamed(Routes.CONTACT);
           }, Images.contact, 'Contact'),
          ],
        ),
      ),
    );
  }

  Widget dialogItem(Function ontap, String image, String title) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Get.back();
          ontap();
        },
        child: Column(
          children: [
            Container(
              height: 9.h,
              width: 18.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColor.primary.withOpacity(0.1)
              ),
              child: Image.asset(image, color: CustomColor.primary, scale: 15,),
            ),
            SizedBox(height: 0.5.h,),
            CustomText(text: title)
          ],
        ),
      ),
    );
  }

  Widget chatFile(String pdfUrl, String time, Color color) {
    return InkWell(
      onTap: (){
        Get.to(PdfScreen(pdfUrl: pdfUrl));
      },
      child: Container(
        height: 18.h,
        width: 50.w,
        padding: EdgeInsets.all(1.5.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SfPdfViewer.network(
              pdfUrl,
              pageLayoutMode: PdfPageLayoutMode.continuous,
              enableDoubleTapZooming: false,
            ),
            Container(
              height: 5.h,
              color: color,
              padding: EdgeInsets.all(1.w),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Images.pdf, height: 3.h,),
                    Text(time,
                        style: TextStyle(fontSize: 1.5.h, color: Colors.black))
                  ]
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chatAudio(String songUrl, String time, Color color) {
    controller.initialAudio(songUrl);
    return Container(
      height: 9.6.h,
      width: 75.w,
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end ,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ControlButtons(controller.audioPlayer),
              StreamBuilder<PositionData>(
                stream: controller.positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: controller.audioPlayer.seek,
                  );
                },
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 1.w),
            child: Text(time,
              style: TextStyle(fontSize: 1.5.h, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
