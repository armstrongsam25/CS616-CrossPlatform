// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

// import 'dart:developer' as developer;

class MainController extends GetxController {
  static MainController get to => Get.find();

  var _user_id = 0.obs;

  get user_id => _user_id.value;
  set user_id(value) => _user_id.value = value;

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() async {
    /*  busy=true; 
    await Future.delayed(const Duration(seconds: 5)).then((val) {
    // Your logic here 
  });
    busy=false;*/
    super.onInit();
  }
}
