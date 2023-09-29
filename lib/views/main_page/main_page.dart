
import 'package:Skywalk/models/user_case.dart';
import 'package:Skywalk/utils/status_codes.dart';
import 'package:Skywalk/views/add_user_case/add_user_case_page.dart';
import 'package:Skywalk/views/common_widgets/common_widgets.dart';
import 'package:Skywalk/views/main_page/controllers/main_page_controller.dart';
import 'package:Skywalk/views/main_page/widgets/case_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'dart:developer' as developer;
 
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> { 

 
  @override
  void initState() {
    
    if (!Get.isRegistered<MainPageController>()) {
      Get.put(MainPageController());
    }
 
    super.initState();
  }
  @override
  Widget build(BuildContext context) { 

    return Scaffold(
 
      appBar: AppBar(title: Text("Signup Page")),
      body: Container( 
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Obx((){
                      if(MainPageController.to.status == STATUS_CODES.QUERY_SUCCESSFULL.code
                      || MainPageController.to.status == STATUS_CODES.USER_CASE_ADDED_SUCCESSFULL.code){ 
                   return getCaseList();
                      }
                      else{
                        return CommonWidgets.getInformationCard(context,MainPageController.to.status);
                      }

                     }
                     
                     
                     ),
                         
                ]),
              ),
            ),
            SizedBox(height: 10,),
          Obx((){
             if (MainPageController.to.busy) {
              return 
                    Center(
                      child: SizedBox(
                      width: 50,
                      height: 50, 
                      child: CircularProgressIndicator( )),
                    );
             }
              else{
                return  SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                            style: ButtonStyle(shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Theme.of(context).colorScheme.secondary)
                            )
                          ) ),
                            onPressed: () {  Get.to(AddUserCasePage());},
                          child: Text("Add New Case")),
                );
              }
              })
          ],
        ),


      ),
    );
  }

Widget  getCaseList(){
   List<UserCase> caseList = MainPageController.to.caseList;

  List<CaseCard> widgetList =  caseList.map((e)=>  CaseCard(userCase: UserCase(user_id: e.user_id, id: e.id, success_rate: e.success_rate,case_name: e.case_name,forgered:e.forgered, completed: e.completed, create_date: e.create_date))    ).toList();
  
  return Column(children: widgetList);
}
 
}