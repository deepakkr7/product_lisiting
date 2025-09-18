// presentation/bloc/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_banners.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/search_products.dart' as search_use_case;
import '../../domain/usecases/toggle_wishlist.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/user_profile.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProducts getProducts;
  final GetBanners getBanners;
  final GetUserProfile getUserProfile;
  final search_use_case.SearchProductsUseCase searchProducts;
  final ToggleWishlist toggleWishlist;

  HomeBloc({
    required this.getProducts,
    required this.getBanners,
    required this.getUserProfile,
    required this.searchProducts,
    required this.toggleWishlist,
  }) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SearchProducts>(_onSearchProducts);
    on<ToggleProductWishlist>(_onToggleWishlist);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      // Load data sequentially to avoid type inference issues
      final productsResult = await getProducts();
      final bannersResult = await getBanners();
      final profileResult = await getUserProfile();

      // Process results
      List<Product> products = [];
      List<Banner> banners = [];
      UserProfile? userProfile;

      productsResult.fold(
            (failure) => print('Failed to load products: ${failure.message}'),
            (data) => products = data,
      );

      bannersResult.fold(
            (failure) => print('Failed to load banners: ${failure.message}'),
            (data) => banners = data,
      );

      profileResult.fold(
            (failure) => print('Failed to load profile: ${failure.message}'),
            (data) => userProfile = data,
      );

      emit(HomeLoaded(
        products: products,
        banners: banners,
        userProfile: userProfile,
      ));
    } catch (e) {
      emit(HomeError('Failed to load home data: $e'));
    }
  }

  Future<void> _onSearchProducts(SearchProducts event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      if (event.query.isEmpty) {
        emit(currentState.copyWith(
          searchResults: [],
          isSearching: false,
        ));
        return;
      }

      emit(currentState.copyWith(isSearching: true));

      final result = await searchProducts(event.query);
      result.fold(
            (failure) => emit(HomeError(failure.message)),
            (searchResults) => emit(currentState.copyWith(
          searchResults: searchResults,
          isSearching: false,
        )),
      );
    }
  }

  Future<void> _onToggleWishlist(ToggleProductWishlist event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      final result = await toggleWishlist(event.productId);
      result.fold(
            (failure) => emit(HomeError(failure.message)),
            (success) {
          // Update product wishlist status in current state
          final updatedProducts = currentState.products.map((product) {
            if (product.id == event.productId) {
              return product.copyWith(isWishlisted: !product.isWishlisted);
            }
            return product;
          }).toList();

          final updatedSearchResults = currentState.searchResults.map((product) {
            if (product.id == event.productId) {
              return product.copyWith(isWishlisted: !product.isWishlisted);
            }
            return product;
          }).toList();

          emit(currentState.copyWith(
            products: updatedProducts,
            searchResults: updatedSearchResults,
          ));
        },
      );
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeData event, Emitter<HomeState> emit) async {
    add(LoadHomeData());
  }
}
