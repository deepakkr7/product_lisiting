import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/network_service.dart';
import '../models/product_model.dart';
import '../models/banner_model.dart';
import '../models/user_profile_model.dart';

abstract class HomeRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, List<BannerModel>>> getBanners();
  Future<Either<Failure, UserProfileModel>> getUserProfile();
  Future<Either<Failure, List<ProductModel>>> getWishlist();
  Future<Either<Failure, bool>> toggleWishlist(int productId);
  Future<Either<Failure, List<ProductModel>>> searchProducts(String query);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final NetworkService networkService;

  HomeRemoteDataSourceImpl({required this.networkService});

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final result = await networkService.get('${AppConstants.baseUrl}/products/');

      return result.fold(
            (failure) => Left(failure),
            (data) {
          return _parseProductList(data);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to fetch products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<BannerModel>>> getBanners() async {
    try {
      final result = await networkService.get('${AppConstants.baseUrl}/banners/');

      return result.fold(
            (failure) => Left(failure),
            (data) {
          return _parseBannerList(data);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to fetch banners: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> getUserProfile() async {
    try {
      final result = await networkService.get('${AppConstants.baseUrl}/user-data/');

      return result.fold(
            (failure) => Left(failure),
            (data) {
          try {
            UserProfileModel profile;

            if (data is Map<String, dynamic>) {
              if (data['user'] != null) {
                profile = UserProfileModel.fromJson(data['user'] as Map<String, dynamic>);
              } else if (data['data'] != null) {
                profile = UserProfileModel.fromJson(data['data'] as Map<String, dynamic>);
              } else {
                profile = UserProfileModel.fromJson(data);
              }
            } else {
              return Left(ServerFailure('Invalid profile data format'));
            }

            print('✅ Parsed user profile: ${profile.name}');
            return Right(profile);
          } catch (e) {
            print('🔴 Profile parsing error: $e');
            return Left(ServerFailure('Failed to parse profile: $e'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to fetch user profile: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getWishlist() async {
    try {
      final result = await networkService.get('${AppConstants.baseUrl}/wishlist/');

      return result.fold(
            (failure) => Left(failure),
            (data) {
          return _parseProductList(data);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to fetch wishlist: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleWishlist(int productId) async {
    try {
      final result = await networkService.post(
        '${AppConstants.baseUrl}/add-remove-wishlist/',
        {'product_id': productId},
      );

      return result.fold(
            (failure) => Left(failure),
            (data) {
          final success = data is Map ? (data['success'] ?? true) : true;
          return Right(success);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to toggle wishlist: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts(String query) async {
    try {
      final result = await networkService.post(
        '${AppConstants.baseUrl}/search/?query=$query',
        {},
      );

      return result.fold(
            (failure) => Left(failure),
            (data) {
          return _parseProductList(data);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to search products: $e'));
    }
  }

  // ✅ CORRECT - Helper method to parse product lists
  Either<Failure, List<ProductModel>> _parseProductList(dynamic data) {
    try {
      List<ProductModel> products = [];

      if (data is List) {
        // ✅ Direct array of products
        products = data
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is Map<String, dynamic>) {
        // ✅ Check for different response structures
        if (data['products'] != null && data['products'] is List) {
          final List<dynamic> productsList = data['products'];
          products = productsList
              .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (data['data'] != null && data['data'] is List) {
          final List<dynamic> productsList = data['data'];
          products = productsList
              .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (data['results'] != null && data['results'] is List) {
          final List<dynamic> productsList = data['results'];
          products = productsList
              .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          // ✅ CORRECT - If Map contains products as values (not as array)
          // Extract all values from Map and convert to List
          final List<dynamic> valuesList = data.values.toList();
          products = valuesList
              .where((item) => item is Map<String, dynamic>)
              .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      print('✅ Parsed ${products.length} products successfully');
      return Right(products);
    } catch (e) {
      print('🔴 Product parsing error: $e');
      return Left(ServerFailure('Failed to parse products: $e'));
    }
  }

  // ✅ CORRECT - Helper method to parse banner lists
  Either<Failure, List<BannerModel>> _parseBannerList(dynamic data) {
    try {
      List<BannerModel> banners = [];

      if (data is List) {
        banners = data
            .map((item) => BannerModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is Map<String, dynamic>) {
        if (data['banners'] != null && data['banners'] is List) {
          final List<dynamic> bannersList = data['banners'];
          banners = bannersList
              .map((item) => BannerModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (data['data'] != null && data['data'] is List) {
          final List<dynamic> bannersList = data['data'];
          banners = bannersList
              .map((item) => BannerModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          // Extract values from Map
          final List<dynamic> valuesList = data.values.toList();
          banners = valuesList
              .where((item) => item is Map<String, dynamic>)
              .map((item) => BannerModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      print('✅ Parsed ${banners.length} banners successfully');
      return Right(banners);
    } catch (e) {
      print('🔴 Banner parsing error: $e');
      return Left(ServerFailure('Failed to parse banners: $e'));
    }
  }

  // ✅ CORRECT - Helper method to parse user profile
  Either<Failure, UserProfileModel> _parseUserProfile(dynamic data) {
    try {
      UserProfileModel profile;

      if (data is Map<String, dynamic>) {
        if (data['user'] != null) {
          profile = UserProfileModel.fromJson(data['user'] as Map<String, dynamic>);
        } else if (data['data'] != null) {
          profile = UserProfileModel.fromJson(data['data'] as Map<String, dynamic>);
        } else {
          profile = UserProfileModel.fromJson(data);
        }
      } else {
        return Left(ServerFailure('Invalid profile data format'));
      }

      print('✅ Parsed user profile: ${profile.name}');
      return Right(profile);
    } catch (e) {
      print('🔴 Profile parsing error: $e');
      return Left(ServerFailure('Failed to parse profile: $e'));
    }
  }
}
