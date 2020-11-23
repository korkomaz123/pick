part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class WishlistLoaded extends WishlistEvent {
  final List<String> ids;
  final String token;
  final String lang;

  WishlistLoaded({this.ids, this.token, this.lang});

  @override
  List<Object> get props => [ids, token, lang];
}

class WishlistInitialized extends WishlistEvent {}
