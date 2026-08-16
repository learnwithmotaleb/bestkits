import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/static_strings/static_strings.dart';
import '../../../../widget/app_text_field.dart';
import '../../../../service/api_url.dart';
import '../../../../widget/app_loading.dart';
import '../controller/message_controller.dart';
import '../page/chat/chat_screen/chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late final MessageController controller;

  @override
  void initState() {
    super.initState();
    // Register controller if not already registered, or find existing one
    if (Get.isRegistered<MessageController>()) {
      controller = Get.find<MessageController>();
    } else {
      controller = Get.put(MessageController());
    }
    // Always refresh on screen entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchChatRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
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
        title: Text(
          AppStrings.chat.tr,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: Dimensions.h(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
            child: AppTextField(
              controller: TextEditingController(),
              hint: AppStrings.search.tr,
              prefixIcon:
                  const Icon(Icons.search, color: Colors.grey, size: 20),
              onChanged: (val) => controller.searchQuery.value = val,
            ),
          ),
          SizedBox(height: Dimensions.h(20)),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const AppLoading(isFullPage: true);
              }

              final items = controller.filteredChats;

              if (items.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => controller.fetchChatRooms(),
                  color: AppColors.primaryColor,
                  backgroundColor: Colors.white,
                  child: ListView(
                    children: [
                      SizedBox(height: Dimensions.h(100)),
                      const Center(child: Text('No chats found')),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchChatRooms(),
                color: AppColors.primaryColor,
                backgroundColor: Colors.white,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final chat = items[index];
                    final isUnread = chat.isUnread;
                    return GestureDetector(
                      onTap: () => Get.to(() => ChatScreen(chatSummary: chat)),
                      child: Container(
                        margin: EdgeInsets.only(bottom: Dimensions.h(12)),
                        padding: EdgeInsets.all(Dimensions.w(16)),
                        decoration: BoxDecoration(
                          color: isUnread
                              ? AppColors.primaryColor.withOpacity(0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(Dimensions.r(12)),
                          border: Border.all(
                            color: isUnread
                                ? AppColors.primaryColor
                                : AppColors.greyColor.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              clipBehavior: Clip.hardEdge,
                              child: chat.avatar.length > 2
                                  ? Image.network(
                                      ApiUrl.buildImageUrl(chat.avatar),
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                      errorBuilder: (_, __, ___) => Text(
                                        chat.name.isNotEmpty
                                            ? chat.name[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Text(
                                      chat.avatar,
                                      style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                            SizedBox(width: Dimensions.w(12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        chat.name,
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                      Text(
                                        chat.time,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 10,
                                          color: isUnread
                                              ? AppColors.primaryColor
                                              : Colors.grey[400],
                                          fontWeight: isUnread
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.h(4)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          chat.lastMessage,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 12,
                                            color: isUnread
                                                ? AppColors.blackColor
                                                : Colors.grey[500],
                                            fontWeight: isUnread
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (chat.unreadCount > 0) ...[
                                        SizedBox(width: Dimensions.w(8)),
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            chat.unreadCount.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
