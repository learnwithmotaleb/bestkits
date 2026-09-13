import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/static_strings/static_strings.dart';
import '../controller/no_internet_controller.dart';

class InternetWrapper extends StatelessWidget {
  final Widget child;

  const InternetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InternetController>();

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          left: 16,
          right: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 12,
          child: SafeArea(
            top: false,
            child: Obx(() {
              final offline = !controller.isConnected.value;
              final checking = controller.isChecking.value;
              final bulgarian = Get.locale?.languageCode == 'bg';
              return IgnorePointer(
                ignoring: !offline,
                child: AnimatedSlide(
                  offset: offline ? Offset.zero : const Offset(0, 0.3),
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: offline ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Semantics(
                          container: true,
                          liveRegion: offline,
                          child: Material(
                            color: const Color(0xFFF5F5F7),
                            elevation: 8,
                            shadowColor: Colors.black26,
                            borderRadius: BorderRadius.circular(22),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                              child: Row(
                                children: [
                                  const Icon(CupertinoIcons.wifi_slash,
                                      color: Color(0xFF636366), size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppStrings.noInternetConnection.tr,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1C1C1E),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          AppStrings.checkYourInternet.tr,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF636366),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  TextButton(
                                    onPressed: checking
                                        ? null
                                        : controller.retryConnection,
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF007AFF),
                                      minimumSize: const Size(64, 44),
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    child: checking
                                        ? Semantics(
                                            label: bulgarian ? 'Проверка на връзката' : 'Checking connection',
                                            child: const CupertinoActivityIndicator(radius: 9),
                                          )
                                        : Text(bulgarian ? 'Повтори' : 'Retry'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
