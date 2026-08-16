import 'package:bestkits/presentation/checkout/controller/checkout_controller.dart';
import 'package:bestkits/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app.dart';
import 'core/device_utls/device_utils.dart';

import 'firebase_options.dart';
import 'global/language/controller/language_controller.dart';
import 'helper/local_db/local_db.dart';
import 'helper/no_internet/controller/no_internet_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences first (Must be before FirebaseNotificationService)
  await SharePrefsHelper.init();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotificationService().initialize();

  // Initialize Google Sign-In (v7.x requirement)
  // NOTE: On Android, you MUST provide the serverClientId (Web Client ID) from Firebase Console.
  // Location: Firebase Console -> Project Settings -> General -> Web API Key/OAuth 2.0 Client IDs -> Web client
  // await GoogleSignIn.instance.initialize(
  //   serverClientId: '222750300065-xxxxxxxxxxxxxxxx.apps.googleusercontent.com', // Replace with your Web Client ID
  // );

  // Lock device orientation
  DeviceUtils.lockDevicePortrait();

  // Controllers
  Get.put(InternetController(), permanent: true);
  Get.put(LanguageController(), permanent: true);
  // Get.put(DeliveryController(), permanent: true);

  runApp(MyApp());
}
