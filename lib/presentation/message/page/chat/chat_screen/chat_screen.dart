import 'package:bestkits/presentation/message/controller/message_controller.dart';
import 'package:bestkits/widget/app_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../../core/responsive_layout/dimensions.dart';
import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../widget/app_button.dart';
import '../../../../../../widget/app_bottom_sheet.dart';
import '../../../../../../widget/app_alert.dart';
import '../chat_controller/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  final ChatSummary chatSummary;
  const ChatScreen({super.key, required this.chatSummary});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatController(), tag: widget.chatSummary.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back,
                  color: AppColors.blackColor, size: 20),
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.chatSummary.avatar,
                style: const TextStyle(
                    color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: Dimensions.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatSummary.name,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (widget.chatSummary.isProfessional) ...[
                    SizedBox(height: Dimensions.h(2)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "• Professional Seller",
                        style: TextStyle(
                            fontSize: 8,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.blackColor),
            onPressed: () => _showChatOptionsBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.w(20), vertical: Dimensions.h(20)),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (msg.dateSeparator != null) ...[
                        Text(
                          msg.dateSeparator!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: Dimensions.h(20)),
                      ],
                      Align(
                        alignment: msg.isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(bottom: Dimensions.h(4)),
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.w(16),
                              vertical: Dimensions.h(12)),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: msg.isMine
                                ? AppColors.primaryColor.withOpacity(0.15)
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(msg.isMine ? 16 : 4),
                              bottomRight: Radius.circular(msg.isMine ? 4 : 16),
                            ),
                            border: msg.isMine
                                ? null
                                : Border.all(
                                    color:
                                        AppColors.greyColor.withOpacity(0.2)),
                          ),
                          child: Text(
                            msg.text,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: msg.isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: Dimensions.h(16), left: 4, right: 4),
                          child: Text(
                            msg.time,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 10,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          Obx(() => _buildBottomInput()),
        ],
      ),
    );
  }

  Widget _buildBottomInput() {
    if (controller.isBlocked.value) {
      return Container(
        padding: EdgeInsets.all(Dimensions.w(24)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: AppColors.greyColor.withOpacity(0.2))),
        ),
        child: Container(
          padding: EdgeInsets.all(Dimensions.w(24)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.speaker_notes_off_outlined,
                    color: Colors.red),
              ),
              SizedBox(height: Dimensions.h(12)),
              const Text(
                "You have blocked this seller",
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Dimensions.h(4)),
              Text(
                "You can't send or receive messages in this conversation.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: Dimensions.h(16)),
              AppButton(
                label: "Unblock Seller",
                onPressed: () => controller.toggleBlock(),
                backgroundColor: const Color(0xFF1A1A1A),
                textColor: AppColors.primaryColor,
                borderSideColor: const Color(0xFF1A1A1A),
                height: 44,
                borderRadius: 8,
              ),
            ],
          ),
        ),
      );
    }

    if (controller.isUnavailable.value) {
      return Container(
        padding: EdgeInsets.all(Dimensions.w(24)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: AppColors.greyColor.withOpacity(0.2))),
        ),
        child: Container(
          padding: EdgeInsets.all(Dimensions.w(24)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.speaker_notes_off_outlined,
                    color: Colors.red),
              ),
              SizedBox(height: Dimensions.h(12)),
              const Text(
                "Messaging is unavailable",
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Dimensions.h(4)),
              Text(
                "You can no longer send messages in this conversation.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(height: Dimensions.h(16)),
              AppButton(
                label: "Delete Conversation",
                onPressed: () => controller.deleteConversation(),
                backgroundColor: const Color(0xFF1A1A1A),
                textColor: AppColors.primaryColor,
                borderSideColor: const Color(0xFF1A1A1A),
                height: 44,
                borderRadius: 8,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(10), vertical: Dimensions.h(16)),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.primaryColor,
            width: 1,
          ),
        ),
        color: AppColors.primaryColor.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppTextField(
                controller: controller.messageController,
                hint: "Enter a message..",

              ),
            ),
          ),
          SizedBox(width: Dimensions.w(12)),
          GestureDetector(
            onTap: () => controller.sendMessage(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.send_rounded,
                  color: AppColors.primaryColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showChatOptionsBottomSheet(BuildContext context) {
    AppBottomSheet(
      child: Container(
        padding: EdgeInsets.all(Dimensions.w(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Options',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: Dimensions.h(20)),
            Obx(() {
              final blocked = controller.isBlocked.value;
              return Column(
                children: [
                  _buildOptionRow(
                    icon: blocked ? Icons.check_circle_outline : Icons.block,
                    label: blocked ? 'Unblock' : 'Block',
                    onTap: () {
                      Get.back();
                      AppAlerts.warning(
                        title: blocked
                            ? 'Unblock This Seller !'
                            : 'Block This Seller !',
                        message: blocked
                            ? 'Do you want to Unblock this Seller and allow messages again?'
                            : "Are you sure you want to block this Seller? You won't be able to send or receive messages with each other.",
                        onConfirm: () => controller.toggleBlock(),
                      );
                    },
                  ),
                  Divider(
                      height: 1, color: AppColors.greyColor.withOpacity(0.2)),
                  _buildOptionRow(
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    isDestructive: true,
                    onTap: () {
                      Get.back();
                      AppAlerts.warning(
                        title: 'Delete Conversation !',
                        message:
                            'This will permanently remove this chat from your messages.',
                        onConfirm: () => controller.deleteConversation(),
                      );
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading:
          Icon(icon, color: isDestructive ? Colors.red : Colors.grey, size: 20),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: isDestructive ? Colors.red : AppColors.darkGreyColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
