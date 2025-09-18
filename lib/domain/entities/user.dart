import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String phoneNumber;
  final String firstName;
  final String? token;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    this.token,
  });

  @override
  List<Object?> get props => [id, phoneNumber, firstName, token];
}