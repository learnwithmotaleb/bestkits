import 'dart:async';
import 'package:bestkits/helper/local_db/local_db.dart';
import 'package:bestkits/presentation/message/model/message_list_model.dart'
    as msg_model;
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/service/socket_service.dart';
import 'package:bestkits/utils/static_strings/static_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  final String chatRoomId;
  ChatController(this.chatRoomId);

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isBlocked = false.obs;
  final RxBool isUnavailable = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isPartnerTyping = false.obs;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ApiClient _apiClient = ApiClient();
  String _currentUserId = '';
  Timer? _typingTimer;

  @override
  void onInit() {
    super.onInit();
    _currentUserId = SharePrefsHelper.getUserId() ?? '';
    _initChat();
    messageController.addListener(_onMessageChanged);
  }

  void _onMessageChanged() {
    if (messageController.text.isNotEmpty) {
      SocketApi.emit('typing', {
        'chatRoomId': int.tryParse(chatRoomId) ?? 0,
        'isTyping': true,
      });

      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 1), () {
        SocketApi.emit('typing', {
          'chatRoomId': int.tryParse(chatRoomId) ?? 0,
          'isTyping': false,
        });
      });
    }
  }

  Future<void> _initChat() async {
    await loadMessages();

    // Connect Socket
    await SocketApi.init();

    // Join room
    SocketApi.emit('join_room', {
      'chatRoomId': int.tryParse(chatRoomId) ?? 0,
    });

    // Mark as read
    SocketApi.emit('mark_read', {
      'chatRoomId': int.tryParse(chatRoomId) ?? 0,
    });

    // Setup listeners
    SocketApi.on('new_message', _handleNewMessage);
    SocketApi.on('messages_read', _handleMessagesRead);
    SocketApi.on('user_typing', _handleTyping);
    SocketApi.on('error', _handleSocketError);
  }

  Future<void> loadMessages() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.messageList(chatRoomId),
        isToken: true,
      );

      if (response.statusCode == 200) {
        final result = msg_model.MessageListModel.fromJson(response.body);
        final list = result.data ?? [];

        messages.clear();
        for (var data in list.reversed) {
          // Reverse to show oldest first if API sends newest first, adjust as needed based on actual API
          messages.add(_mapToChatMessage(data));
        }
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint("Failed to load messages: $e");
    } finally {
      isLoading.value = false;
    }
  }

  ChatMessage _mapToChatMessage(msg_model.Data data) {
    bool isMine = data.senderId.toString() == _currentUserId;
    DateTime date =
        DateTime.tryParse(data.createdAt ?? '')?.toLocal() ?? DateTime.now();
    String formattedTime = DateFormat('hh:mm a').format(date);

    return ChatMessage(
      id: data.id.toString(),
      text: data.message ?? '',
      isMine: isMine,
      time: formattedTime,
    );
  }

  void _handleNewMessage(dynamic data) {
    debugPrint("📥 new_message: $data");
    try {
      final msgData = msg_model.Data.fromJson(data as Map<String, dynamic>);
      messages.add(_mapToChatMessage(msgData));
      _scrollToBottom();

      SocketApi.emit('mark_read', {
        'chatRoomId': int.tryParse(chatRoomId) ?? 0,
      });
    } catch (e) {
      debugPrint("Error parsing new message: $e");
    }
  }

  void _handleMessagesRead(dynamic data) {
    debugPrint("📥 messages_read: $data");
  }

  void _handleTyping(dynamic data) {
    debugPrint("📥 user_typing: $data");
    if (data['chatRoomId'].toString() == chatRoomId &&
        data['userId'].toString() != _currentUserId) {
      isPartnerTyping.value = data['isTyping'] ?? false;
    }
  }

  void _handleSocketError(dynamic message) {
    Get.snackbar("Chat Error", message.toString());
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    SocketApi.emit("send_message", {
      "chatRoomId": int.tryParse(chatRoomId) ?? 0,
      "message": text,
      "type": "TEXT"
    });

    messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> toggleBlock() async {
    try {
      final isCurrentlyBlocked = isBlocked.value;
      final url = isCurrentlyBlocked
          ? ApiUrl.messageUnblock(chatRoomId)
          : ApiUrl.messageBlock(chatRoomId);

      final response = await _apiClient.patch(
        url: url,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isBlocked.value = !isCurrentlyBlocked;
        if (isBlocked.value) {
          isUnavailable.value = false;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update block status");
    }
  }

  Future<void> deleteConversation() async {
    try {
      final response = await _apiClient.delete(
        url: ApiUrl.messageDelete(chatRoomId),
        isToken: true,
      );

      if (response.statusCode == 200) {
        messages.clear();
        isUnavailable.value = true;
        isBlocked.value = false;
        Get.back();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete conversation");
    }
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    messageController.removeListener(_onMessageChanged);
    messageController.dispose();
    scrollController.dispose();

    SocketApi.emit('leave_room', {
      'chatRoomId': int.tryParse(chatRoomId) ?? 0,
    });

    SocketApi.off('new_message');
    SocketApi.off('messages_read');
    SocketApi.off('user_typing');
    SocketApi.off('error');

    super.onClose();
  }
}
