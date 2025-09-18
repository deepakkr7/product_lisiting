import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../../core/utils/validators.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class VerifyUser {
  final AuthRepository repository;

  VerifyUser(this.repository);

  Future<Either<Failure, AuthResponse>> call(String phoneNumber) async {
    if (!Validators.isValidPhoneNumber(phoneNumber)) {
      return const Left(ValidationFailure('Please enter a valid phone number'));
    }

    return await repository.verifyUser(phoneNumber);
  }
}