import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/utils/status_codes.dart';
import 'package:Skywalk/views/common_widgets/common_widgets.dart';
import 'package:Skywalk/views/login_page/controllers/login_page_controller.dart';
import 'package:Skywalk/views/main_page/main_page.dart';
import 'package:Skywalk/views/signup_page/signup_page.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    developer.log('init', name: 'init');
    if (!Get.isRegistered<LoginPageController>()) {
      Get.put(LoginPageController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.65;

    return Scaffold(
      backgroundColor: Color(0xFF0033A0),
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Color.fromARGB(255, 4, 30, 68),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: maxWidth,
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CrossPlatform - SafeWalk',
                    style: TextStyle(
                        fontSize: 44.0,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 252, 251, 255)),
                  ),
                  SizedBox(height: 24.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Username',
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
                    controller: _passwordController,
                    obscureText: true,
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
                    if (!LoginPageController.to.busy) {
                      return ElevatedButton(
                        onPressed: () async {
                          Status status = await LoginPageController.to.login(
                              _emailController.text, _passwordController.text);
                          if (status.code ==
                              STATUS_CODES.LOGIN_SUCCESSFULL.code) {
                            Get.off(MainPage());
                          } else {
                            SnackBar snackBar =
                                CommonWidgets.getAweSomeSnackBar(status);

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(
                              0xFF0033A0), // Set the background color to UKY blue
                          onPrimary:
                              Colors.white, // Set the text color to white
                          side: BorderSide(
                              color: Colors.white,
                              width: 2.0), // Set the border to white
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 20.0), // Add padding to increase size
                          textStyle: TextStyle(
                            fontSize: 18, // You can adjust font size here
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // You can adjust border radius here
                          ),
                        ),
                        child: Text('Login'),
                      );
                    } else {
                      developer.log('busy', name: 'loginpage');
                      return SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator());
                    }
                  }),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () => {Get.off(SignUpPage())},
                    child: Text("Don't you have an account?"),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 18, // You can adjust font size here
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
