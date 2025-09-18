import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../entities/product.dart';
import '../repositories/home_repository.dart';

class GetWishlist {
  final HomeRepository repository;

  GetWishlist(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getWishlist();
  }
}