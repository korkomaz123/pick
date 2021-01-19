part of 'wishlist_item_count_bloc.dart';

abstract class WishlistItemCountEvent extends Equatable {
  const WishlistItemCountEvent();

  @override
  List<Object> get props => [];
}

class WishlistItemCountSet extends WishlistItemCountEvent {
  final int wishlistItemCount;

  WishlistItemCountSet({this.wishlistItemCount});

  @override
  List<Object> get props => [wishlistItemCount];
}
