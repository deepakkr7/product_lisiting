import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class VerifyPhoneNumber extends AuthEvent {
  final String phoneNumber;

  const VerifyPhoneNumber(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}
class VerifyOTP extends AuthEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOTP(this.phoneNumber, this.otp);

  @override
  List<Object> get props => [phoneNumber, otp];
}

class RegisterUser extends AuthEvent {
  final String phoneNumber;
  final String firstName;

  const RegisterUser(this.phoneNumber, this.firstName);

  @override
  List<Object> get props => [phoneNumber, firstName];
}

class LogoutUser extends AuthEvent {}
