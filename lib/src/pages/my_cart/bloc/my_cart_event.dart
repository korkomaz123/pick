part of 'my_cart_bloc.dart';

abstract class MyCartEvent extends Equatable {
  const MyCartEvent();

  @override
  List<Object> get props => [];
}

class MyCartCreated extends MyCartEvent {}

class MyCartItemsLoaded extends MyCartEvent {
  final String cartId;

  MyCartItemsLoaded({this.cartId});

  @override
  List<Object> get props => [cartId];
}

class MyCartItemAdded extends MyCartEvent {
  final String cartId;
  final String productId;
  final String qty;

  MyCartItemAdded({this.cartId, this.productId, this.qty});

  @override
  List<Object> get props => [cartId, productId, qty];
}

class MyCartItemUpdated extends MyCartEvent {
  final String cartId;
  final String itemId;
  final String qty;

  MyCartItemUpdated({this.cartId, this.itemId, this.qty});

  @override
  List<Object> get props => [cartId, itemId, qty];
}

class MyCartItemRemoved extends MyCartEvent {
  final String cartId;
  final String itemId;

  MyCartItemRemoved({this.cartId, this.itemId});

  @override
  List<Object> get props => [cartId, itemId];
}

class MyCartItemsCleared extends MyCartEvent {
  final String cartId;

  MyCartItemsCleared({this.cartId});

  @override
  List<Object> get props => [cartId];
}
