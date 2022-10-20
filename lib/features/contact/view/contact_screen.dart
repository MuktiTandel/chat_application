import 'dart:convert';
import 'dart:typed_data';

import 'package:chat_application/core/elements/custom_title.dart';
import 'package:chat_application/core/elements/customcolor.dart';
import 'package:chat_application/core/elements/customtext.dart';
import 'package:chat_application/core/models/contact_model.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:chat_application/core/utils/images.dart';
import 'package:chat_application/features/contact/controller/contact_controller.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreen extends StatelessWidget {
   ContactScreen({Key? key}) : super(key: key);

  final controller = Get.put(ContactController());

  Constance constance = Constance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: CustomColor.primary
        ),
        title: Text('Contacts',
          style: TextStyle(color: CustomColor.primary, fontWeight: FontWeight.bold, fontSize: 3.h),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Obx(() => controller.IsList.value == false ?  const Center(
          child: CustomTitle(title: 'No Contacts'),
        ) :ListView.builder(
            itemCount: controller.contacts_data.length,
            itemBuilder: (BuildContext context, int index){
              controller.getImage(controller.contacts_data[index].id);
              return InkWell(
                onTap: (){
                  ContactDetail contactDetail = ContactDetail(
                      displayname: controller.contacts_data[index].displayname,
                      id: controller.contacts_data[index].id,
                      image: controller.thumbnail!,
                      email: (controller.contacts_data[index].emails.isNotEmpty) ? controller.contacts_data[index].emails[0] : '',
                      phone: controller.contacts_data[index].phones[0],
                  );
                  controller.senddata(jsonEncode(contactDetail));
                  Get.back();
                },
                child: Row(
                  children: [
                    GetBuilder<ContactController>(
                      builder: (context) {
                        return Container(
                          height: 6.5.h,
                          width: 13.w,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black12
                          ),
                          child: (controller.thumbnail != null) ? ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.memory(controller.thumbnail!, fit: BoxFit.fill,)) : ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(Images.user, height: 3.h,)),
                        );
                      }
                    ),
                    SizedBox(width: 3.w,),
                    CustomText(
                        text: (controller.contacts_data[index].displayname.isNotEmpty) ? controller.contacts_data[index].displayname : controller.contacts_data[index].phones[0],
                      fontsize: 2.5.h,
                    )
                  ],
                ),
              );
            })),
      ),
    );
  }
}
