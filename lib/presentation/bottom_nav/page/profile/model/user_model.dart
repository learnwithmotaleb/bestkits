class UserModel {
  final bool success;
  final int statusCode;
  final UserData data;

  UserModel({
    required this.success,
    required this.statusCode,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json['success'],
      statusCode: json['statusCode'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final int id;
  final String email;
  final bool emailVerifird;
  final bool isBlocked;
  final int profileId;
  final String role;
  final String? stripeAccountId;
  final bool stripeOnboardingComplete;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Profile profile;

  UserData({
    required this.id,
    required this.email,
    required this.emailVerifird,
    required this.isBlocked,
    required this.profileId,
    required this.role,
    this.stripeAccountId,
    required this.stripeOnboardingComplete,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      emailVerifird: json['email_verifird'],
      isBlocked: json['is_blocked'],
      profileId: json['profile_id'],
      role: json['role'],
      stripeAccountId: json['stripe_account_id'],
      stripeOnboardingComplete: json['stripe_onboarding_complete'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      profile: Profile.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'email_verifird': emailVerifird,
      'is_blocked': isBlocked,
      'profile_id': profileId,
      'role': role,
      'stripe_account_id': stripeAccountId,
      'stripe_onboarding_complete': stripeOnboardingComplete,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profile': profile.toJson(),
    };
  }
}

class Profile {
  final int id;
  final String? avatarUrl;
  final String fullName;
  final String phone;
  final String? country;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    this.avatarUrl,
    required this.fullName,
    required this.phone,
    this.country,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      avatarUrl: json['avatar_url'],
      fullName: json['full_name'],
      phone: json['phone'],
      country: json['country'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar_url': avatarUrl,
      'full_name': fullName,
      'phone': phone,
      'country': country,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}