import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isMine;
  final String time;
  final String? dateSeparator; // e.g. "TODAY"

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMine,
    required this.time,
    this.dateSeparator,
  });
}

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isBlocked = false.obs;
  final RxBool isUnavailable = false.obs;
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Load dummy messages
    messages.addAll([
      ChatMessage(
        id: '1',
        text: 'Hey! I just wanted to confirm our meeting for tomorrow at 10am. Does that suit you?',
        isMine: false,
        time: '04:45 PM',
        dateSeparator: AppStrings.today.tr,
      ),
      ChatMessage(
        id: '2',
        text: "Yes, all clear! I've been working on the sketches you showed me.",
        isMine: true,
        time: '04:45 PM',
      ),
      ChatMessage(
        id: '3',
        text: "I'm glad to hear that! See you tomorrow at the meeting!",
        isMine: false,
        time: '04:45 PM',
      ),
    ]);
  }

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: messageController.text.trim(),
          isMine: true,
          time: AppStrings.justNow.tr,
        ),
      );
      messageController.clear();
    }
  }

  void toggleBlock() {
    isBlocked.value = !isBlocked.value;
    if (isBlocked.value) {
      isUnavailable.value = false;
    }
  }

  void deleteConversation() {
    messages.clear();
    // Just simulating unavailability after deletion for demo purposes
    isUnavailable.value = true;
    isBlocked.value = false;
  }
}