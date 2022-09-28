import 'dart:ui';

import 'package:chat_application/core/localization/en_US.dart';
import 'package:get/get.dart';

class TranslationService extends Translations{

  static Locale? get locale => Get.deviceLocale;

  static final fallbackLocale = Locale('en', 'Us');

  @override
  Map<String, Map<String, String>> get keys => {
    'en_Us' : English.en_US,
  };

}