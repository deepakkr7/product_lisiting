import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class SearchProducts extends HomeEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleProductWishlist extends HomeEvent {
  final int productId;

  const ToggleProductWishlist(this.productId);

  @override
  List<Object> get props => [productId];
}

class RefreshHomeData extends HomeEvent {}