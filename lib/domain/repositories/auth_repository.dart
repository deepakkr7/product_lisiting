import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../entities/auth_response.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> verifyUser(String phoneNumber);
  Future<Either<Failure, AuthResponse>> loginRegister(String phoneNumber, String firstName);
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> saveUser(User user);
}