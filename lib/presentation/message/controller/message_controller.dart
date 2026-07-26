import 'package:get/get.dart';

class ChatSummary {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final bool isUnread;
  final int unreadCount;
  final bool isProfessional;

  ChatSummary({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    this.isUnread = false,
    this.unreadCount = 0,
    this.isProfessional = false,
  });
}

class MessageController extends GetxController {
  final RxString searchQuery = ''.obs;

  final List<ChatSummary> chats = [
    ChatSummary(id: '1', name: 'Mayoral Reseller', avatar: 'M', lastMessage: 'Hi, I would like to check the payment sta...', time: '25 min ago', isUnread: true, isProfessional: true),
    ChatSummary(id: '2', name: 'Junona Kids', avatar: 'J', lastMessage: 'Hi, I would like to check the payment sta...', time: '25 min ago', isUnread: true, unreadCount: 2),
    ChatSummary(id: '3', name: 'Tochici', avatar: 'T', lastMessage: 'Hi, I would like to check the payment sta...', time: '04:45 PM'),
    ChatSummary(id: '4', name: 'Chrisma', avatar: 'C', lastMessage: 'Hi, I would like to check the payment sta...', time: '04:55 PM'),
    ChatSummary(id: '5', name: 'Chipolino', avatar: 'C', lastMessage: 'Hi, I would like to check the payment sta...', time: '02:45 AM'),
  ];

  List<ChatSummary> get filteredChats {
    if (searchQuery.value.isEmpty) return chats;
    return chats.where((c) => c.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:jeebjab/helper/local_db/local_db.dart';
// import 'package:jeebjab/service/api_service.dart';
// import 'package:jeebjab/service/api_url.dart';
// import 'package:jeebjab/service/socket_service.dart';
// import 'package:jeebjab/utils/assets_image/app_images.dart';
// import '../model/get_message_model.dart';
//
// class ChatController extends GetxController {
//   final TextEditingController messageController = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//
//   // ── Chat session info (set from navigation arguments) ──────────────────────
//   RxString chatId = ''.obs;
//   RxString receiverId = ''.obs;
//
//   // ── Observable messages list ───────────────────────────────────────────────
//   RxList<MessageModel> messages = <MessageModel>[].obs;
//   RxBool isLoading = false.obs;
//
//   final ApiClient _apiClient = ApiClient();
//   final ImagePicker _picker = ImagePicker();
//   String currentUserId = '';
//
//   // ── Delivery / driver status ───────────────────────────────────────────────
//   RxString deliveryStatus = 'pending'.obs; // pending, active, completed
//   RxString driverName = 'Driver'.obs;
//   RxString driverImage = AppImages.profileImage.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadCurrentUser();
//     loadChatData();
//     _initSocket();
//   }
//
//   Future<void> _initSocket() async {
//     await SocketApi.init();
//     _listenToMessages();
//   }
//
//   void _listenToMessages() {
//     SocketApi.on('new_message', (data) {
//       debugPrint("📥 Socket [new_message] received: $data");
//       if (data['chatId'] == chatId.value) {
//         messages.insert(0, MessageModel.fromJson(data as Map<String, dynamic>));
//       }
//     });
//
//     SocketApi.on('receive_message', (data) {
//       debugPrint("📥 Socket [receive_message] received: $data");
//       if (data['chatId'] == chatId.value) {
//         messages.insert(0, MessageModel.fromJson(data as Map<String, dynamic>));
//       }
//     });
//   }
//
//   void _loadCurrentUser() {
//     currentUserId = SharePrefsHelper.getUserId() ?? '';
//   }
//
//   // ── Load arguments passed from StatusDetailsController ───────────────────
//   void loadChatData() {
//     if (Get.arguments != null) {
//       final args = Get.arguments as Map<String, dynamic>;
//       chatId.value = args['chatId'] ?? '';
//       receiverId.value = args['receiverId'] ?? '';
//       deliveryStatus.value = args['status'] ?? 'pending';
//       driverName.value = args['driverName'] ?? 'Driver';
//       driverImage.value = args['driverImage'] ?? AppImages.profileImage;
//     }
//
//     // TODO: Connect WebSocket here once chatId is ready
//     // TODO: Load message history from API
//     loadMessages();
//   }
//
//   Future<void> loadMessages() async {
//     if (chatId.value.isEmpty) return;
//
//     try {
//       isLoading.value = true;
//       final response = await _apiClient.get(
//         url: ApiUrl.getChatMessage(chatId.value),
//         isToken: true,
//       );
//
//       if (response.statusCode == 200) {
//         final result = GetMessageModel.fromJson(response.body);
//         messages.assignAll(result.data);
//       }
//     } catch (e) {
//       debugPrint("Failed to load messages: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void sendMessage() {
//     if (deliveryStatus.value == 'completed') {
//       Get.snackbar(
//         'Not Available',
//         'You cannot send messages after the order is completed',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.amber[700],
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//       );
//       return;
//     }
//
//     final text = messageController.text.trim();
//     if (text.isEmpty) return;
//
//     // Optimistically add the message to the UI
//     final newMessage = MessageModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       sender: MessageUserModel(id: currentUserId, name: 'You'),
//       receiver: MessageUserModel(id: receiverId.value, name: driverName.value),
//       chatId: chatId.value,
//       message: text,
//       messageType: 'text',
//       isRead: false,
//       createdAt: DateTime.now().toIso8601String(),
//       updatedAt: DateTime.now().toIso8601String(),
//     );
//
//     messages.insert(0, newMessage);
//     messageController.clear();
//
//     // Emit via WebSocket
//     SocketApi.emit('send_message', {
//       'chatId': chatId.value,
//       'receiverId': receiverId.value,
//       'message': text,
//     });
//   }
//
//   Future<void> pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         await _uploadAndSendMedia(File(image.path));
//       }
//     } catch (e) {
//       debugPrint("Error picking image: $e");
//     }
//   }
//
//   Future<void> _uploadAndSendMedia(File file) async {
//     try {
//       isLoading.value = true;
//       final response = await _apiClient.multipart(
//         url: ApiUrl.uploadMedia,
//         fields: {},
//         files: [MultipartFileData(key: 'chat_media', path: file.path)],
//         isToken: true,
//       );
//
//       if (response.statusCode == 200) {
//         final data = response.body['data'];
//         final fileUrl = data['fileUrl'];
//         final messageType = data['messageType'];
//
//         // Optimistically add the message to the UI
//         final newMessage = MessageModel(
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           sender: MessageUserModel(id: currentUserId, name: 'You'),
//           receiver: MessageUserModel(
//             id: receiverId.value,
//             name: driverName.value,
//           ),
//           chatId: chatId.value,
//           message: '',
//           fileUrl: fileUrl,
//           messageType: messageType,
//           isRead: false,
//           createdAt: DateTime.now().toIso8601String(),
//           updatedAt: DateTime.now().toIso8601String(),
//         );
//
//         messages.insert(0, newMessage);
//
//         // Emit via WebSocket
//         SocketApi.emit('send_message', {
//           'chatId': chatId.value,
//           'receiverId': receiverId.value,
//           'message': '',
//           'fileUrl': fileUrl,
//           'messageType': messageType,
//         });
//       }
//     } catch (e) {
//       debugPrint("Error uploading media: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void scrollToBottom() {
//     // When using reverse: true on ListView, we scroll to 0.0 to reach the bottom.
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           0.0,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void addFile() {
//     // ✅ BLOCK FILE UPLOAD ONLY IF DELIVERED
//     if (deliveryStatus.value == 'delivered') {
//       Get.snackbar(
//         'Not Available',
//         'You cannot share files after delivery',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.amber[700],
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//       );
//       return;
//     }
//
//     // TODO: Implement file picker
//     Get.snackbar(
//       'Add File',
//       'File picker functionality',
//       snackPosition: SnackPosition.BOTTOM,
//       duration: const Duration(seconds: 2),
//     );
//   }
//
//   @override
//   void onClose() {
//     SocketApi.off('new_message');
//     SocketApi.off('receive_message');
//     messageController.dispose();
//     scrollController.dispose();
//     super.onClose();
//   }
// }
