import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final result = await remoteDataSource.getProducts();
      return result.fold(
            (failure) => Left(failure),
            (products) => Right(products),
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Banner>>> getBanners() async {
    try {
      final result = await remoteDataSource.getBanners();
      return result.fold(
            (failure) => Left(failure),
            (banners) => Right(banners),
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final result = await remoteDataSource.getUserProfile();
      return result.fold(
            (failure) => Left(failure),
            (profile) => Right(profile),
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getWishlist() async {
    try {
      final result = await remoteDataSource.getWishlist();
      return result.fold(
            (failure) => Left(failure),
            (products) => Right(products),
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleWishlist(int productId) async {
    try {
      final result = await remoteDataSource.toggleWishlist(productId);
      return result.fold(
            (failure) => Left(failure),
            (success) => Right(success),
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final result = await remoteDataSource.searchProducts(query);
      return result.fold(
            (failure) => Left(failure),
            (products) => Right(products),
      );
    } catch (e) {
      return Left(ServerFailure('Repository error: $e'));
    }
  }
}