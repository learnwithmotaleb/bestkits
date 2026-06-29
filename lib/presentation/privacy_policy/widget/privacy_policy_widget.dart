import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';

import '../../../../core/responsive_layout/dimensions.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  final RxString htmlContent;

  const PrivacyPolicyWidget({super.key, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.w(20),
            vertical: Dimensions.h(16),
          ),
          child: Html(
            data: htmlContent.value,
            style: {
              "p": Style(
                fontSize: FontSize(Dimensions.fs(12)),
                color: Colors.black87,
              ),
              "h1": Style(
                fontSize: FontSize(Dimensions.fs(16)),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: Colors.black,
                margin: Margins.only(bottom: Dimensions.h(12)),
              ),
            },
          ),
        ));
  }
}
