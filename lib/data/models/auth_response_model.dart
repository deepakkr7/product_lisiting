// data/models/auth_response_model.dart
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import 'user_model.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required bool success,
    required String message,
    required bool userExists,
    String? token,
    User? user,
    String? otp,
  }) : super(
    success: success,
    message: message,
    userExists: userExists,
    token: token,
    user: user,
    otp: otp,
  );

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    print('🔍 Raw API Response: $json');

    // Check if this is a verify response or login-register response
    if (json.containsKey('otp')) {
      // This is a verify response: {"otp":"8912","user":false}
      final bool apiUserExists = json['user'] == true;
      print('🔍 Verify API - user exists: $apiUserExists');

      return AuthResponseModel(
        success: true,
        message: 'Phone verification completed',
        userExists: apiUserExists,
        token: null,
        user: null,
        otp: json['otp']?.toString(),
      );
    } else {
      // This is a login-register response: {"token":{"access":"..."},"user_id":"ta0192","message":"Login Successful"}
      print('🔍 Login-Register API Response');

      final tokenData = json['token'];
      final accessToken = tokenData is Map ? tokenData['access']?.toString() : tokenData?.toString();
      final userId = json['user_id']?.toString();
      final message = json['message']?.toString() ?? 'Success';

      print('🔍 Extracted token: ${accessToken?.substring(0, 20)}...');
      print('🔍 Extracted user_id: $userId');

      // Create a user object from the response
      UserModel? user;
      if (userId != null) {
        user = UserModel(
          id: userId,
          phoneNumber: '', // We'll get this from the registration context
          firstName: '', // We'll get this from the registration context
          token: accessToken,
        );
      }

      return AuthResponseModel(
        success: message.toLowerCase().contains('successful') || message.toLowerCase().contains('success'),
        message: message,
        userExists: true, // User now exists after registration
        token: accessToken,
        user: user,
        otp: null,
      );
    }
  }
}
