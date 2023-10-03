import 'package:Skywalk/app_controllers/main_controller.dart';
import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/models/user.dart';
import 'package:Skywalk/services/apis.dart';
import 'package:Skywalk/utils/status_codes.dart';
import 'package:get/get.dart';

import 'dart:developer' as developer;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class SignupPageController extends GetxController {
  var _busy = true.obs;

  get busy => _busy.value;
  set busy(value) => _busy.value = value;
  var _isSelected = false.obs;

  get isSelected => _isSelected.value;
  set isSelected(value) => _isSelected.value = value;

  static SignupPageController get to => Get.find();

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

  Future<Status> signup(String email, String password) async {
    busy = true;
    try {
      final SignUpResult signUpResult = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: email,
          // CognitoUserAttributeKey.givenName: name,
          // CognitoUserAttributeKey.familyName: lastname,
        }),
      );

      if (signUpResult.isSignUpComplete) {
        return Status(
          code: STATUS_CODES.USER_ADDED_SUCCESSFULL.code,
          codeString: 'User Added Successfully',
          type: 1, // Replace with the correct type value for successful signup
          value: 1, // Replace with the correct value for successful signup
          data: "Sign up successful, please confirm your email",
        );
      } else {
        return Status(
          code: STATUS_CODES.USER_CONFIRMATION_REQUIRED.code,
          codeString: 'User Confirmation Required',
          type:
              2, // Replace with the correct type value for user confirmation required
          value:
              1, // Replace with the correct value for user confirmation required
          data: 'User confirmation required',
        );
      }
    } on AmplifyException catch (e) {
      return Status(
        code: STATUS_CODES.SIGNUP_ERROR.code,
        codeString: 'Sign Up Error',
        type: 3, // Replace with the correct type value for signup error
        value: 1, // Replace with the correct value for signup error
        data: 'Sign up error - ${e.message}',
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
