import 'package:equatable/equatable.dart';
import 'package:product_lisiting/domain/entities/user.dart';

class AuthResponse extends Equatable {
  final bool success;
  final String message;
  final bool userExists;
  final String? token;
  final User? user;
  final String? otp; // Add OTP field

  const AuthResponse({
    required this.success,
    required this.message,
    required this.userExists,
    this.token,
    this.user,
    this.otp, // Add this
  });

  @override
  List<Object?> get props => [success, message, userExists, token, user, otp];
}
