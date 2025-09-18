import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);
  @override
  List<Object> get props => [user];
}

class PhoneVerificationRequired extends AuthState {
  final String phoneNumber;
  final bool isNewUser;
  final String? otp; // Add OTP field

  const PhoneVerificationRequired({
    required this.phoneNumber,
    required this.isNewUser,
    this.otp, // Add this
  });

  @override
  List<Object?> get props => [phoneNumber, isNewUser, otp];
}
class RegistrationRequired extends AuthState {
  final String phoneNumber;

  const RegistrationRequired(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}