import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../core/storage/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<Either<Failure, UserModel?>> getCurrentUser();
  Future<Either<Failure, void>> saveUser(UserModel user);
  Future<Either<Failure, void>> clearUser();
  Future<Either<Failure, String?>> getStoredToken();
  Future<Either<Failure, bool>> hasValidToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService storageService;

  AuthLocalDataSourceImpl({required this.storageService});

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final userJson = await storageService.getString(AppConstants.userKey);
      if (userJson != null) {
        final user = UserModel.fromJson(json.decode(userJson));

        // Verify token is still valid
        final hasToken = await storageService.hasValidToken();
        if (hasToken) {
          print('✅ Current user found with valid token');
          return Right(user);
        } else {
          print('❌ User found but token invalid - clearing user data');
          await clearUser();
          return const Right(null);
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await storageService.saveString(AppConstants.userKey, userJson);

      // Save JWT token separately
      if (user.token != null && user.token!.isNotEmpty) {
        await storageService.saveToken(user.token!);
      }

      // Mark user as logged in
      await storageService.saveString(AppConstants.isLoggedInKey, 'true');

      print('✅ User and token saved successfully');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to save user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearUser() async {
    try {
      await storageService.remove(AppConstants.userKey);
      await storageService.clearToken();
      await storageService.remove(AppConstants.isLoggedInKey);

      print('✅ User data and token cleared');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to clear user: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> getStoredToken() async {
    try {
      final token = await storageService.getToken();
      return Right(token);
    } catch (e) {
      return Left(ServerFailure('Failed to get stored token: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasValidToken() async {
    try {
      final hasToken = await storageService.hasValidToken();
      return Right(hasToken);
    } catch (e) {
      return Left(ServerFailure('Failed to check token validity: $e'));
    }
  }
}