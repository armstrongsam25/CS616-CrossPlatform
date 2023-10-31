import 'package:Skywalk/app_controllers/main_controller.dart';
import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/models/user_case.dart';
import 'package:Skywalk/services/apis.dart';
import 'package:Skywalk/utils/status_codes.dart';
import 'package:get/get.dart';

import 'dart:developer' as developer;

class MainPageController extends GetxController {
  var _busy = false.obs;

  var _status = STATUS_CODES.DATA_LENGTH_ZERO.code.obs;

  get status => _status.value;
  set status(value) => _status.value = value;

  get busy => _busy.value;
  set busy(value) => _busy.value = value;

  var _caseList = <UserCase>[].obs;

  get caseList => _caseList;
  set caseList(value) => _caseList.value = value;
  // burada list olustur. onInit icerisinden listeye at ve listede degisiklik olunca sayfayi guncelle.

  static MainPageController get to => Get.find();

  @override
  void onReady() async {
    await getUsercases();

    developer.log("OnReady", name: 'MainPageController');
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void addUserCase(UserCase userCase) {
    busy = true;
    status = STATUS_CODES.USER_CASE_ADDED_SUCCESSFULL.code;
    caseList.add(userCase);
    caseList.refresh();
    busy = false;
  }

  Future<void> getUsercases() async {
    busy = true;
    Status result =
        await ApiServices.to.getUserCaseList(MainController.to.user_id);
    status = result.code;
    if (result.code == STATUS_CODES.QUERY_SUCCESSFULL.code) {
      caseList = result.data;

      for (int i = 0; i < result.data.length; i++) {
        developer.log(result.data[i].toJson().toString(),
            name: 'MainPageController');
      }
    } else {
      developer.log(result.codeString, name: 'MainPageController');
      caseList = <UserCase>[];
    }
    busy = false;
  }

  @override
  void onInit() async {
    super.onInit();
  }
}
