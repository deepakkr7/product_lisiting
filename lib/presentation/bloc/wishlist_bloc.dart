import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_wish_list.dart';
import '../../domain/usecases/toggle_wishlist.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlist getWishlist;
  final ToggleWishlist toggleWishlist;

  WishlistBloc({
    required this.getWishlist,
    required this.toggleWishlist,
  }) : super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
    on<RefreshWishlist>(_onRefreshWishlist);

    add(LoadWishlist());
  }

  Future<void> _onLoadWishlist(
      LoadWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    // Check if bloc is closed before proceeding
    if (isClosed) return;

    emit(WishlistLoading());

    try {
      final result = await getWishlist();

      // Check again before emitting
      if (isClosed) return;

      result.fold(
            (failure) {
          if (!isClosed) emit(WishlistError(failure.message));
        },
            (products) {
          if (!isClosed) emit(WishlistLoaded(products));
        },
      );
    } catch (e) {
      if (!isClosed) emit(WishlistError('Failed to load wishlist: $e'));
    }
  }

  Future<void> _onRemoveFromWishlist(
      RemoveFromWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    if (isClosed || state is! WishlistLoaded) return;

    final currentState = state as WishlistLoaded;

    try {
      final result = await toggleWishlist(event.productId);

      if (isClosed) return;

      result.fold(
            (failure) {
          if (!isClosed) emit(WishlistError(failure.message));
        },
            (success) {
          if (!isClosed) {
            final updatedProducts = currentState.products
                .where((product) => product.id != event.productId)
                .toList();
            emit(WishlistLoaded(updatedProducts));
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(WishlistError('Failed to remove from wishlist: $e'));
    }
  }

  Future<void> _onRefreshWishlist(
      RefreshWishlist event,
      Emitter<WishlistState> emit,
      ) async {
    if (!isClosed) add(LoadWishlist());
  }

  @override
  Future<void> close() async {
    // Add any cleanup logic here if needed
    return super.close();
  }
}
