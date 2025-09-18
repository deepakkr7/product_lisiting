import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/user_profile.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> products;
  final List<Banner> banners;
  final UserProfile? userProfile;
  final List<Product> searchResults;
  final bool isSearching;

  const HomeLoaded({
    required this.products,
    required this.banners,
    this.userProfile,
    this.searchResults = const [],
    this.isSearching = false,
  });

  @override
  List<Object?> get props => [products, banners, userProfile, searchResults, isSearching];

  HomeLoaded copyWith({
    List<Product>? products,
    List<Banner>? banners,
    UserProfile? userProfile,
    List<Product>? searchResults,
    bool? isSearching,
  }) {
    return HomeLoaded(
      products: products ?? this.products,
      banners: banners ?? this.banners,
      userProfile: userProfile ?? this.userProfile,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}