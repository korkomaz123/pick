part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class WishlistLoaded extends WishlistEvent {
  final String token;
  final String lang;

  WishlistLoaded({this.token, this.lang});

  @override
  List<Object> get props => [token, lang];
}

class WishlistAdded extends WishlistEvent {
  final String token;
  final String productId;

  WishlistAdded({this.token, this.productId});

  @override
  List<Object> get props => [token, productId];
}

class WishlistRemoved extends WishlistEvent {
  final String token;
  final String productId;

  WishlistRemoved({this.token, this.productId});

  @override
  List<Object> get props => [token, productId];
}

class WishlistInitialized extends WishlistEvent {}
