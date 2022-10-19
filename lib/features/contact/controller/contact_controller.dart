import 'package:chat_application/core/utils/constance.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {

  Constance constance = Constance();

  @override
  void onInit() {
   super.onInit();
   getContact();
  }

  Future getContact() async {

    final contacts = Contacts.listContacts();
    final total = await contacts.length;

    constance.Debug('$total');

  }
}