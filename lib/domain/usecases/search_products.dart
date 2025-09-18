import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../entities/product.dart';
import '../repositories/home_repository.dart';

class SearchProductsUseCase {  // Renamed to avoid conflict
  final HomeRepository repository;

  SearchProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call(String query) async {
    if (query.isEmpty) {
      return const Left(ValidationFailure('Search query cannot be empty'));
    }
    return await repository.searchProducts(query);
  }
}