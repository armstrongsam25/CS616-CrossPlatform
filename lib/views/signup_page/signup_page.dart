import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/utils/status_codes.dart';
// import 'package:Skywalk/views/common_widgets/common_widgets.dart';
import 'package:Skywalk/views/login_page/login_page.dart';
import 'package:Skywalk/views/main_page/main_page.dart';
import 'package:Skywalk/views/signup_page/controllers/signup_page_controller.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  Future<String?> _showConfirmationDialog(BuildContext context) async {
    TextEditingController _confirmationCodeController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation Required'),
          content: TextField(
            controller: _confirmationCodeController,
            decoration: InputDecoration(
              labelText: 'Confirmation Code',
            ),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, _confirmationCodeController.text),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    if (!Get.isRegistered<SignupPageController>()) {
      Get.put(SignupPageController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.65;

    return Scaffold(
      backgroundColor: Color(0xFF0033A0),
      appBar: AppBar(
        title: Text("Signup Page"),
        backgroundColor: Color.fromARGB(255, 4, 30, 68),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: maxWidth,
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                    // TextFormField(
                    //           controller: _nameController,
                    //           keyboardType: TextInputType.name,
                    //           decoration: InputDecoration(
                    //             labelText: 'Name',
                    //           ),
                    //              validator: (value) {
                    //             if (value!.isEmpty) {
                    //               return 'Please fill username field.';
                    //             }
                    //             return null;
                    //           },
                    //         ),
                    //         SizedBox(height: 16.0),
                    // TextFormField(
                    //           controller: _lastnameController,
                    //           keyboardType: TextInputType.name,
                    //           decoration: InputDecoration(
                    //             labelText: 'last name',
                    //           ),
                    //              validator: (value) {
                    //             if (value!.isEmpty) {
                    //               return 'Please fill last name field.';
                    //             }
                    //             return null;
                    //           },
                    //         ),
                    //         SizedBox(height: 16.0),

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
                        return ElevatedButton(
                          onPressed: () async {
                            Status status =
                                await SignupPageController.to.signup(
                              _emailController.text,
                              _password2Controller.text,
                            );

                            if (status.code ==
                                STATUS_CODES.USER_CONFIRMATION_REQUIRED.code) {
                              String? confirmationCode =
                                  await _showConfirmationDialog(
                                      context); // Show a dialog and get the user's input

                              if (confirmationCode != null) {
                                try {
                                  await Amplify.Auth.confirmSignUp(
                                    username: _emailController.text,
                                    confirmationCode: confirmationCode,
                                  );
                                  // After successful confirmation, you may want to navigate to the main page or login page
                                  Get.off(
                                      MainPage()); // or some other action according to your app logic
                                } catch (e) {
                                  // Handle error during confirmation, maybe show a SnackBar with error message
                                  final snackBar = SnackBar(
                                      content:
                                          Text('Error confirming sign up: $e'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            } else if (status.code ==
                                STATUS_CODES.USER_ADDED_SUCCESSFULL.code) {
                              Get.off(MainPage());
                            } else {
                              // Handle other statuses, like showing a SnackBar with an error message
                              final snackBar = SnackBar(
                                  content: Text(
                                      'Error signing up: ${status.codeString}'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
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
                          child: Text('SignUp'),
                        );
                      } else {
                        developer.log('busy', name: 'signuppage');

                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),

                    SizedBox(height: 16.0),

                    TextButton(
                      onPressed: () => {Get.off(LoginPage())},
                      child: Text("Already have an account? "),
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        textStyle: TextStyle(
                          fontSize: 18, // You can adjust font size here
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
