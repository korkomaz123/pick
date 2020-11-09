part of 'ciga_app_bloc.dart';

abstract class CigaAppEvent extends Equatable {
  const CigaAppEvent();

  @override
  List<Object> get props => [];
}

class CartItemCountIncremented extends CigaAppEvent {
  final int incrementedCount;

  CartItemCountIncremented({this.incrementedCount});

  @override
  List<Object> get props => [incrementedCount];
}

class CartItemCountDecremented extends CigaAppEvent {
  final int decrementedCount;

  CartItemCountDecremented({this.decrementedCount});

  @override
  List<Object> get props => [decrementedCount];
}

class CartItemCountSet extends CigaAppEvent {
  final int cartItemCount;

  CartItemCountSet({this.cartItemCount});

  @override
  List<Object> get props => [cartItemCount];
}

class CartItemCountUpdated extends CigaAppEvent {
  final List<CartItemEntity> cartItems;

  CartItemCountUpdated({this.cartItems});

  @override
  List<Object> get props => [cartItems];
}
