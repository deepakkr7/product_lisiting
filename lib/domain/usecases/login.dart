import 'package:dartz/dartz.dart';

import '../../core/ errors/failures.dart';
import '../../core/utils/validators.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginRegister {
  final AuthRepository repository;

  LoginRegister(this.repository);

  Future<Either<Failure, AuthResponse>> call(
      String phoneNumber,
      String firstName,
      ) async {
    if (!Validators.isValidPhoneNumber(phoneNumber)) {
      return const Left(ValidationFailure('Please enter a valid phone number'));
    }

    if (!Validators.isValidName(firstName)) {
      return const Left(ValidationFailure('Please enter a valid name'));
    }

    return await repository.loginRegister(phoneNumber, firstName);
  }
}