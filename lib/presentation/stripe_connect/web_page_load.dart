import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bestkits/widget/custom_appbar.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';

class StripeWebPageLoadScreen extends StatefulWidget {
  const StripeWebPageLoadScreen({super.key});

  @override
  State<StripeWebPageLoadScreen> createState() =>
      _StripeWebPageLoadScreenState();
}

class _StripeWebPageLoadScreenState extends State<StripeWebPageLoadScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final url = Get.arguments as String? ?? '';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Intercept callback URLs to close the webview automatically
            if (request.url.startsWith('bestkits://stripe/callback') ||
                request.url.startsWith('bestkits://stripe/refresh') ||
                request.url.contains('sparktech.agency') ||
                request.url.contains('localhost')) {
              Get.back();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CommonAppBar(
        title: 'Stripe Connect',
        showBack: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
