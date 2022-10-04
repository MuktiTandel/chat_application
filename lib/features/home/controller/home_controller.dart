import 'package:chat_application/core/controller/database_controller.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  final databaseController = Get.put(DatabaseController());

  Constance constance = Constance();

  @override
  void onInit() {
    super.onInit();
    databaseController.database.ref().once().then((value) {
      constance.Debug('Get User data = ${value.snapshot.value}');
    } );
  }

}