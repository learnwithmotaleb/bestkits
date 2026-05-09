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