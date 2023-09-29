
import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/utils/status_codes.dart';
import 'package:Skywalk/views/common_widgets/common_widgets.dart';
import 'package:Skywalk/views/login_page/login_page.dart';
import 'package:Skywalk/views/main_page/main_page.dart';
import 'package:Skywalk/views/signup_page/controllers/signup_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 

import 'dart:developer' as developer;
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final TextEditingController _emailController = TextEditingController();
   final TextEditingController _nameController = TextEditingController();
   final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); 
  final TextEditingController _password2Controller = TextEditingController(); 
  @override
  void initState() {
    
    if (!Get.isRegistered<SignupPageController>()) {
      Get.put(SignupPageController());
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double maxWidth= MediaQuery.of(context).size.width * 0.65;

    return Scaffold(
      appBar: AppBar(title: Text("Signup Page")),
      body: Center(child: Container(
        width: maxWidth,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key:   _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
          TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      
                      labelText: 'Email Address',
                    ),
                       validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill email field.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
          TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                       validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill username field.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
          TextFormField(
                    controller: _lastnameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'last name',
                    ),
                       validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill last name field.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
        
               TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _passwordController, 
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                       validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill last name field.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
        
                  
            TextFormField(
                    controller: _password2Controller,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill password field.';
                      }
                      return null;
                    },
                  ),
          
                  SizedBox(height: 16.0),
                  
                Obx(() {
                  if (!SignupPageController.to.busy) {
 
                    return 
                ElevatedButton(
                  onPressed: () async {

                    Status status= await SignupPageController.to.signup(_emailController.text, _nameController.text, _lastnameController.text, _password2Controller.text);
                     if(status.code == STATUS_CODES.USER_ADDED_SUCCESSFULL.code){
                    Get.off(MainPage());
                   }
                   else{

                    SnackBar snackBar= CommonWidgets.getAweSomeSnackBar(status);
                    
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);

                   }
                       SnackBar snackBar= CommonWidgets.getAweSomeSnackBar(status);

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
                  },
                  child: Text('SignUp'),
                );
                  }

                else{
                    developer.log('busy', name: 'signuppage');

          return SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator( ));
                }



                }),
        
                  SizedBox(height: 16.0),
                  
                  TextButton(
                    onPressed: ()=>{ Get.off(LoginPage())},
                    child: Text("Already have an account? "),
                  ),
            ]),
          ),
        ),


      ),),
    );
  }
 
}