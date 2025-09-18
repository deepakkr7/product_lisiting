import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../repositories/home_repository.dart';


class ToggleWishlist {
  final HomeRepository repository;

  ToggleWishlist(this.repository);

  Future<Either<Failure, bool>> call(int productId) async {
    return await repository.toggleWishlist(productId);
  }
}