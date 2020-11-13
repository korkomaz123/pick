part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class WishlistLoaded extends WishlistEvent {
  final List<String> ids;
  final String token;

  WishlistLoaded({this.ids, this.token});

  @override
  List<Object> get props => [ids, token];
}

class WishlistInitialized extends WishlistEvent {}
