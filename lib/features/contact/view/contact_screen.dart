import 'package:chat_application/core/elements/customcolor.dart';
import 'package:chat_application/core/sizer/sizer.dart';
import 'package:chat_application/features/contact/controller/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreen extends StatelessWidget {
   ContactScreen({Key? key}) : super(key: key);

  final controller = Get.put(ContactController());

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
      body: Container(),
    );
  }
}
