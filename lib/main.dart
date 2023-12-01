import 'package:flutter/material.dart';
import 'app.dart';
import 'amplify_configuration.dart'; // Import the Amplify configuration file.

void main() async {
  await configureAmplify(); // Call the configureAmplify function before running the app.
  runApp(App());
}

//ayushkarki92@gmail.com
//ayushkarki12