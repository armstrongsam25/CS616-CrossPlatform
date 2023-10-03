import 'package:Skywalk/app_controllers/main_controller.dart';
import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/services/apis.dart';
import 'package:Skywalk/utils/status_codes.dart';
import 'package:get/get.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:developer' as developer;

class LoginPageController extends GetxController {
  var _busy = true.obs;

  get busy => _busy.value;
  set busy(value) => _busy.value = value;
  var _isSelected = false.obs;

  get isSelected => _isSelected.value;
  set isSelected(value) => _isSelected.value = value;

  static LoginPageController get to => Get.find();

  @override
  void onReady() async {
    busy = true;
    int result = await ApiServices.to.checkConnection();
    busy = false;

    developer.log(result.toString(), name: 'ApiServices');
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<Status> login(String email, String password) async {
    busy = true;
    try {
      final SignInResult result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        // Assuming `value` is meant to hold some user ID or other identifier.
        return Status(
          code: STATUS_CODES.LOGIN_SUCCESSFULL.code, // Example success code
          codeString: 'Login successful',
          type: 1, // Use the correct type
          value: 1, // Use the correct value
        );
      } else {
        return Status(
          code: 401, // Example failure code
          codeString: 'Login failed',
          type: 0, // Use the correct type
          value: 0, // Use the correct value
        );
      }
    } on AmplifyException catch (e) {
      return Status(
        code: 500, // Example error code
        codeString: 'Login error - ${e.message}',
        type: -1, // Use the correct type
        value: -1, // Use the correct value
      );
    } finally {
      busy = false;
    }
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
