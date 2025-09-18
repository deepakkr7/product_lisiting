import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../entities/banner.dart';
import '../repositories/home_repository.dart';

class GetBanners {
  final HomeRepository repository;

  GetBanners(this.repository);

  Future<Either<Failure, List<Banner>>> call() async {
    return await repository.getBanners();
  }
}