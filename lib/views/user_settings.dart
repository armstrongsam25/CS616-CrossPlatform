 

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
 
  TextEditingController _newpasswordTextPasswordController= TextEditingController();
  TextEditingController _oldpasswordTextPasswordController= TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context)  {
    return Scaffold(  
    
      appBar: AppBar(
        title: Text("User Settings Page"),
        
      ),
     
      body:  Center(
        child: Container(
            padding: EdgeInsets.all(15),
      
          child: Column(children: [
               TextField(
              controller: _userNameTextController,
              decoration: InputDecoration(hintText: "Write your new email address"),
            ),
            
        SizedBox(height: 15,),
               TextField(
              obscureText: true,
              controller: _oldpasswordTextPasswordController,
              decoration: InputDecoration(hintText: "Write your old password address"),
            ),

        SizedBox(height: 15,),
               TextField(
              obscureText: true,
              controller: _newpasswordTextPasswordController,
              decoration: InputDecoration(hintText: "Write your new password address"),
            ),
        SizedBox(height: 15,),
            Center(child: TextButton(onPressed: (){




              if( _newpasswordTextPasswordController.text == _oldpasswordTextPasswordController.text){
 

 _showBottomSheet(context, "Your old password and new password should not be the same!"); 
              }
              else { 
      
      

_showBottomSheet(context, "Password has been changed successfully!"); 
   //    Navigator.of(context).pop();
              } 
            }, child: Text("Save"))), 
      
          ]),
        ),
      )
    );
  }




 void _showBottomSheet(BuildContext context, message) {
    showModalBottomSheet(
      context: context,
      
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[ 
                Card(
                  child: ListTile(
                    title: Text("Warning"),
                    subtitle: Text(message),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}