import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../../../core/responsive_layout/responsive_layout.dart';
import '../../../../../../global/language/controller/language_controller.dart';
import '../../../../../../utils/app_colors/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final lc = Get.find<LanguageController>(); // ← find, not put

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Center(child: Text("Home Screen"),),
    );
  }




}