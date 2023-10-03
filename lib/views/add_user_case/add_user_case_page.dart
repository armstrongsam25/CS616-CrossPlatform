import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/utils/status_codes.dart';
import 'package:Skywalk/views/add_user_case/controllers/add_user_case_page_controller.dart';
import 'package:Skywalk/views/add_user_case/widgets/camera_widget.dart';
import 'package:Skywalk/views/common_widgets/common_widgets.dart';
import 'package:Skywalk/views/main_page/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:developer' as developer;

class AddUserCasePage extends StatefulWidget {
  const AddUserCasePage({super.key});

  @override
  State<AddUserCasePage> createState() => _AddUserCasePageState();
}

class _AddUserCasePageState extends State<AddUserCasePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userCaseName = TextEditingController();
  int cnt = 0;
  @override
  void initState() {
    if (!Get.isRegistered<AddUserCasePageController>()) {
      Get.put(AddUserCasePageController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add User Case")),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _userCaseName,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Case Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please submit a case name.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Suspected Signature: "),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CameraWidget(callback: cameraCallBack),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Original Signature: "),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CameraWidget(callback: cameraCallBack),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Obx(() {
              if (!AddUserCasePageController.to.busy) {
                return SizedBox(
                    width: double.infinity, // <-- Your width
                    height: 50, // <-- Your height
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)))),
                      onPressed: () async {
                        Status status = await AddUserCasePageController.to
                            .addUserCase(_userCaseName.text);
                        SnackBar snackBar =
                            CommonWidgets.getAweSomeSnackBar(status);
                        if (status.code ==
                            STATUS_CODES.USER_CASE_ADDED_SUCCESSFULL.code) {
                          MainPageController.to.addUserCase(status.data);
                        }
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      },
                      child: Text("Save"),
                    ));
              } else {
                developer.log('busy', name: 'addusercasepage');

                return SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator());
              }
            }),
          ],
        ),
      ),
    );
  }

  void cameraCallBack() {
    cnt += 1;
    developer.log("cnt: " + cnt.toString());
  }
}
