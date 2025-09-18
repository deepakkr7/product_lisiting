import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../entities/product.dart';
import '../entities/banner.dart';
import '../entities/user_profile.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, List<Banner>>> getBanners();
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, List<Product>>> getWishlist();
  Future<Either<Failure, bool>> toggleWishlist(int productId);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}