import 'package:Skywalk/app_controllers/main_controller.dart';
import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/services/apis.dart';
import 'package:get/get.dart'; 
 
import 'dart:developer' as developer;
class LoginPageController extends GetxController{
 
  var _busy=true.obs;
 

  get busy => _busy.value;
  set busy(value) => _busy.value = value;
  var _isSelected = false.obs;
 

  get isSelected => _isSelected.value;
  set isSelected(value) => _isSelected.value = value;

  static LoginPageController get to => Get.find();

  @override
  void onReady() async {
    busy=true;
    int result = await ApiServices.to.checkConnection();
    busy=false;

    developer.log(result.toString(), name: 'ApiServices');
    super.onReady();
  }
@override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    
  }

  Future<Status> login(String email,String password) async {
    busy=true;
    Status result = await ApiServices.to.login(email,password);
    MainController.to.user_id= result.value;
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