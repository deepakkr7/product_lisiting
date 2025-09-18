import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    String? profileImageUrl,
  }) : super(
    id: id,
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    profileImageUrl: profileImageUrl,
  );

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      name: json['name'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? json['phone'] ?? json['mobile'] ?? '',
      profileImageUrl: json['profile_image'] ?? json['avatar'] ?? json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image': profileImageUrl,
    };
  }
}
