import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String phoneNumber,
    required String firstName,
    String? token,
  }) : super(
    id: id,
    phoneNumber: phoneNumber,
    firstName: firstName,
    token: token,
  );
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'token': token,
    };
  }
}