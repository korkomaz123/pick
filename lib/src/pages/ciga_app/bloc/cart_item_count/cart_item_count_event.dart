part of 'cart_item_count_bloc.dart';

abstract class CartItemCountEvent extends Equatable {
  const CartItemCountEvent();

  @override
  List<Object> get props => [];
}

class CartItemCountIncremented extends CartItemCountEvent {
  final int incrementedCount;

  CartItemCountIncremented({this.incrementedCount});

  @override
  List<Object> get props => [incrementedCount];
}

class CartItemCountDecremented extends CartItemCountEvent {
  final int decrementedCount;

  CartItemCountDecremented({this.decrementedCount});

  @override
  List<Object> get props => [decrementedCount];
}

class CartItemCountSet extends CartItemCountEvent {
  final int cartItemCount;

  CartItemCountSet({this.cartItemCount});

  @override
  List<Object> get props => [cartItemCount];
}

class CartItemCountUpdated extends CartItemCountEvent {
  final List<CartItemEntity> cartItems;

  CartItemCountUpdated({this.cartItems});

  @override
  List<Object> get props => [cartItems];
}
