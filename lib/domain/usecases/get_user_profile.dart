import 'package:dartz/dartz.dart';
import '../../core/ errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/home_repository.dart';

class GetUserProfile {
  final HomeRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, UserProfile>> call() async {
    return await repository.getUserProfile();
  }
}