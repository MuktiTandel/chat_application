import 'dart:io';

import 'package:chat_application/core/elements/custombutton.dart';
import 'package:chat_application/core/elements/customcolor.dart';
import 'package:chat_application/core/elements/customtext.dart';
import 'package:chat_application/core/models/user_model.dart';
import 'package:chat_application/core/routes/app_routes.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:chat_application/core/utils/firebase_constant.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:chat_application/features/home/controller/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);

  final controller = Get.put(HomeController());

  final firestoreInstanc = FirebaseFirestore.instance;

  int _limit = 20;

  Constance constance = Constance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Chat Application',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'SourceSansPro',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: (){
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColor.primary.withOpacity(0.1)
                ),
                child: Image.asset(Images.search, color: CustomColor.primary, scale: 13,),
              ),
            ),
          ),
          Container(width: 14.w,
            margin: const EdgeInsets.only(left: 0, right: 15),
            child: InkWell(
              onTap: (){},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColor.primary.withOpacity(0.1)
                ),
                child: Image.asset(Images.menu, color: CustomColor.primary, scale: 18,),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.all(4.w),
        child: StreamBuilder<QuerySnapshot>(
          stream: controller.getFireStoreData(FirebaseConstant.pathUserCollection, _limit, controller.search.text),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
                if((snapshot.data?.docs.length ?? 0) > 0){
                  return ListView.separated(
                    shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index){
                        return listview(snapshot.data!.docs[index]);
                      },
                      separatorBuilder: (BuildContext context, int index){
                        return SizedBox(height: 2.h,);
                      },
                      itemCount: snapshot.data!.docs.length
                  );
                } else {
                  return nochat();
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: CustomColor.primary,),
                );
              }
            })
      ),
    );
  }

  Widget nochat() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 8.h,
                    width: 16.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: CustomColor.primary
                    ),
                  ),
                  Container(
                    height: 4.h,
                    width: 8.w,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                    child: const Icon(Icons.check_rounded, color: CustomColor.primary,),
                  )
                ]
            ),
            SizedBox(height: 5.h,),
            CustomText(
              text: "You haven't chat yet",
              fontWeight: FontWeight.bold,
              fontsize: 20.sp,
              color: CustomColor.primary,
            ),
            SizedBox(height: 3.h,),
            SizedBox(
                width: 50.w,
                child: CustomButton(
                    borderRadius: 35,
                    backgroundColor: CustomColor.primary,
                    ontap: (){},
                    buttontext: 'Start Chatting')
            )
          ],
        )
    );
  }

  Widget listview(DocumentSnapshot snapshot) {
    UserModel userData = UserModel.fromDocument(snapshot);
    constance.Debug('User data => ${userData.toMap()}');
    return InkWell(
      onTap: (){
        Get.toNamed(Routes.CHAT, arguments: userData);
      },
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black12
            ),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(24),
                child: Image.network(userData.image, fit: BoxFit.fill,),
              ),
            ),
          ),
          SizedBox(width: 5.w,),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: userData.username,
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              const CustomText(
                text: 'last message',
                color: Colors.black45,
              )
            ],
          )
        ],
      ),
    );
  }
}
