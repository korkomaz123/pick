part of 'wishlist_item_count_bloc.dart';

class WishlistItemCountState extends Equatable {
  final int wishlistItemCount;

  WishlistItemCountState({this.wishlistItemCount});

  WishlistItemCountState init() {
    return WishlistItemCountState(
      wishlistItemCount: 0,
    );
  }

  WishlistItemCountState update(int updatedCount) {
    return WishlistItemCountState(
      wishlistItemCount: updatedCount ?? this.wishlistItemCount,
    );
  }

  @override
  List<Object> get props => [wishlistItemCount];
}
