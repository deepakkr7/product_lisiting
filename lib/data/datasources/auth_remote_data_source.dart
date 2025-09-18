import 'package:dartz/dartz.dart';

import '../../core/ errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/network_service.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, AuthResponseModel>> verifyUser(String phoneNumber);
  Future<Either<Failure, AuthResponseModel>> loginRegister(
      String phoneNumber,
      String firstName,
      );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkService networkService;

  AuthRemoteDataSourceImpl({required this.networkService});

  @override
  Future<Either<Failure, AuthResponseModel>> verifyUser(
      String phoneNumber) async {
    try {
      final result = await networkService.post(
        AppConstants.verifyUserEndpoint,
        {'phone_number': phoneNumber},
      );

      return result.fold(
            (failure) => Left(failure),
            (data) {
          final response = AuthResponseModel.fromJson(data);
          return Right(response);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to verify user: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> loginRegister(String phoneNumber,
      String firstName,) async {
    try {
      final result = await networkService.post(
        AppConstants.loginRegisterEndpoint,
        {
          'phone_number': phoneNumber,
          'first_name': firstName,
        },
      );

      return result.fold(
            (failure) => Left(failure),
            (data) {
          final response = AuthResponseModel.fromJson(data);
          return Right(response);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to login/register: $e'));
    }
  }
}