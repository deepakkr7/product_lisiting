import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../entities/product.dart';
import '../repositories/home_repository.dart';


class GetProducts {
  final HomeRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}