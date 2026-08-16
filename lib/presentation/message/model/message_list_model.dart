class MessageListModel {
  bool? success;
  int? statusCode;
  String? message;
  List<Data>? data;
  Meta? meta;

  MessageListModel(
      {this.success, this.statusCode, this.message, this.data, this.meta});

  MessageListModel.fromJson(Map<String, dynamic> json) {
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
  int? chatRoomId;
  int? senderId;
  String? message;
  Null? fileUrl;
  bool? isRead;
  bool? isDelivered;
  String? type;
  String? createdAt;
  String? updatedAt;
  Sender? sender;

  Data(
      {this.id,
        this.chatRoomId,
        this.senderId,
        this.message,
        this.fileUrl,
        this.isRead,
        this.isDelivered,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.sender});

  Data.fromJson(Map<String, dynamic> json) {
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
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
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
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    return data;
  }
}

class Sender {
  int? id;
  Profile? profile;

  Sender({this.id, this.profile});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
