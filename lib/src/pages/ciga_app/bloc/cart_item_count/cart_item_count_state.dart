part of 'cart_item_count_bloc.dart';

class CartItemCountState extends Equatable {
  CartItemCountState({this.cartItemCount});

  final int cartItemCount;

  CartItemCountState init() {
    return CartItemCountState(
      cartItemCount: 0,
    );
  }

  CartItemCountState setCartCount(int cartItemCount) {
    return CartItemCountState(
      cartItemCount: cartItemCount ?? this.cartItemCount,
    );
  }

  @override
  List<Object> get props => [cartItemCount];
}
