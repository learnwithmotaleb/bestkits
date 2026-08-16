class MyChatRoomModel {
  bool? success;
  int? statusCode;
  String? message;
  List<Data>? data;
  Meta? meta;

  MyChatRoomModel(
      {this.success, this.statusCode, this.message, this.data, this.meta});

  MyChatRoomModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  Partner? partner;
  LastMessage? lastMessage;
  int? unreadCount;
  bool? isBlocked;
  bool? blockedByMe;
  bool? blockedByPartner;
  Null? blockedAt;
  bool? deletedForMe;
  bool? messagingAvailable;
  Null? unavailableReason;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.partner,
      this.lastMessage,
      this.unreadCount,
      this.isBlocked,
      this.blockedByMe,
      this.blockedByPartner,
      this.blockedAt,
      this.deletedForMe,
      this.messagingAvailable,
      this.unavailableReason,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partner =
        json['partner'] != null ? new Partner.fromJson(json['partner']) : null;
    lastMessage = json['lastMessage'] != null
        ? new LastMessage.fromJson(json['lastMessage'])
        : null;
    unreadCount = json['unread_count'];
    isBlocked = json['is_blocked'];
    blockedByMe = json['blocked_by_me'];
    blockedByPartner = json['blocked_by_partner'];
    blockedAt = json['blocked_at'];
    deletedForMe = json['deleted_for_me'];
    messagingAvailable = json['messaging_available'];
    unavailableReason = json['unavailable_reason'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.partner != null) {
      data['partner'] = this.partner!.toJson();
    }
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage!.toJson();
    }
    data['unread_count'] = this.unreadCount;
    data['is_blocked'] = this.isBlocked;
    data['blocked_by_me'] = this.blockedByMe;
    data['blocked_by_partner'] = this.blockedByPartner;
    data['blocked_at'] = this.blockedAt;
    data['deleted_for_me'] = this.deletedForMe;
    data['messaging_available'] = this.messagingAvailable;
    data['unavailable_reason'] = this.unavailableReason;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Partner {
  int? id;
  String? email;
  String? sellerTier;
  Profile? profile;

  Partner({this.id, this.email, this.sellerTier, this.profile});

  Partner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    sellerTier = json['seller_tier'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['seller_tier'] = this.sellerTier;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? fullName;
  String? avatarUrl;

  Profile({this.fullName, this.avatarUrl});

  Profile.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['avatar_url'] = this.avatarUrl;
    return data;
  }
}

class LastMessage {
  int? id;
  int? chatRoomId;
  int? senderId;
  String? message;
  Null? fileUrl;
  bool? isRead;
  bool? isDelivered;
  String? type;
  String? createdAt;
  String? updatedAt;

  LastMessage(
      {this.id,
      this.chatRoomId,
      this.senderId,
      this.message,
      this.fileUrl,
      this.isRead,
      this.isDelivered,
      this.type,
      this.createdAt,
      this.updatedAt});

  LastMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatRoomId = json['chatRoomId'];
    senderId = json['senderId'];
    message = json['message'];
    fileUrl = json['file_url'];
    isRead = json['is_read'];
    isDelivered = json['is_delivered'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chatRoomId'] = this.chatRoomId;
    data['senderId'] = this.senderId;
    data['message'] = this.message;
    data['file_url'] = this.fileUrl;
    data['is_read'] = this.isRead;
    data['is_delivered'] = this.isDelivered;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Meta {
  int? total;
  int? page;
  int? limit;
  int? pages;

  Meta({this.total, this.page, this.limit, this.pages});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['pages'] = this.pages;
    return data;
  }
}
