import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'amplifyconfiguration.dart';

Future<void> configureAmplify() async {
  try {
    Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
    print('Amplify configured successfully');
  } catch (e) {
    print('Failed to configure Amplify $e');
  }
}
