import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_repository_impl.dart' as localDataSource;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthResponse>> verifyUser(String phoneNumber) async {
    try {
      final result = await remoteDataSource.verifyUser(phoneNumber);
      return result.fold(
            (failure) => Left(failure),
            (response) => Right(response),
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }
  @override
  Future<Either<Failure, AuthResponse>> loginRegister(
      String phoneNumber,
      String firstName,
      ) async {
    try {
      final result = await remoteDataSource.loginRegister(phoneNumber, firstName);
      return result.fold(
            (failure) => Left(failure),
            (response) async {
          // Save user locally if authentication successful
          if (response.success && response.user != null && response.token != null) {
            // Create complete user object with token
            final completeUser = UserModel(
              id: response.user!.id,
              phoneNumber: phoneNumber,
              firstName: firstName.isNotEmpty ? firstName : 'User',
              token: response.token,
            );

            // Save user and token to local storage
            await localDataSource.saveUser(completeUser);

            print('✅ User registered/logged in and saved locally');

            // Return response with complete user data
            return Right(AuthResponseModel(
              success: response.success,
              message: response.message,
              userExists: response.userExists,
              token: response.token,
              user: completeUser,
            ));
          }
          return Right(response);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }

@override
Future<Either<Failure, User?>> getCurrentUser() async {
  try {
    print('🔍 Checking for current user...');

    // First check if we have a valid token
    final tokenResult = await localDataSource.hasValidToken();
    final hasValidToken = tokenResult.fold((l) => false, (r) => r);

    if (!hasValidToken) {
      print('❌ No valid token found');
      return const Right(null);
    }

    // Get user data
    final result = await localDataSource.getCurrentUser();
    return result.fold(
          (failure) => Left(failure),
          (user) {
        if (user != null) {
          print('✅ Current user found: ${user.firstName} (${user.id})');
        } else {
          print('ℹ️ No current user found');
        }
        return Right(user);
      },
    );
  } catch (e) {
    return Left(ServerFailure('Repository error: $e'));
  }
}
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final result = await localDataSource.clearUser();
      return result.fold(
            (failure) => Left(failure),
            (_) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }
  @override
  Future<Either<Failure, void>> saveUser(User user) async {
    try {
      final result = await localDataSource.saveUser(user as UserModel);
      return result.fold(
            (failure) => Left(failure),
            (_) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }
}