part of 'wishlist_bloc.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoadedInProcess extends WishlistState {}

class WishlistLoadedSuccess extends WishlistState {
  final List<ProductModel> wishlists;

  WishlistLoadedSuccess({this.wishlists});

  @override
  List<Object> get props => [wishlists];
}

class WishlistLoadedFailure extends WishlistState {
  final String message;

  WishlistLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}
