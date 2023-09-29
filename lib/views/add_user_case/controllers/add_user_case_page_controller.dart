// ignore_for_file: non_constant_identifier_names

import 'package:Skywalk/app_controllers/main_controller.dart';
import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/models/user_case.dart';
import 'package:Skywalk/services/apis.dart';
import 'package:get/get.dart'; 
 
import 'dart:developer' as developer;
class AddUserCasePageController extends GetxController{
 
  var _busy=false.obs;
 

  get busy => _busy.value;
  set busy(value) => _busy.value = value; 
 
 

  static AddUserCasePageController get to => Get.find();

  @override
  void onReady() async { 
    super.onReady();
  }
@override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    
  }


  Future<Status> addUserCase(String case_name) async{

    busy=true;
    UserCase userCase=UserCase(user_id: MainController.to.user_id,  case_name: case_name); 
    Status result = await ApiServices.to.addUserCase(userCase);
    
    developer.log(result.data.toJson().toString(), name: 'MainPageController');
    busy=false;


return result;

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