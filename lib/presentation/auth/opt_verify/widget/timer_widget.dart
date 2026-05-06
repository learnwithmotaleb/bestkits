import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/utils/app_text_style/app_text_style.dart';
import 'package:bestkits/core/responsive_layout/dimensions.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.onResendCode});

  final VoidCallback onResendCode;

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int totalTimeInSeconds;
  Timer? _timer;
  bool showResend = false;

  @override
  void initState() {
    super.initState();
    totalTimeInSeconds = 30; // Matches design's "Resend in 00:30" start
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (totalTimeInSeconds > 0) {
        setState(() {
          totalTimeInSeconds--;
        });
      } else {
        setState(() {
          showResend = true;
        });
        timer.cancel();
      }
    });
  }

  void resetTimer() {
    setState(() {
      totalTimeInSeconds = 30;
      showResend = false;
    });
    startTimer();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Didn't receive the code?",
          style: AppTextStyles.body.copyWith(
            fontSize: Dimensions.fs(14),
            color: AppColors.greyColor,
          ),
        ),
        GestureDetector(
          onTap: showResend
              ? () {
            widget.onResendCode();
            resetTimer();
          }
              : null,
          child: Text(
            showResend
                ? "Resend Code"
                : "Resend in ${formatTime(totalTimeInSeconds)}",
            style: AppTextStyles.body.copyWith(
                fontSize: Dimensions.fs(14),
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor
            ),
          ),
        ),
      ],
    );
  }
}
