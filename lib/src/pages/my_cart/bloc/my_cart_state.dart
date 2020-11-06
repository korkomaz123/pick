part of 'my_cart_bloc.dart';

abstract class MyCartState extends Equatable {
  const MyCartState();

  @override
  List<Object> get props => [];
}

class MyCartInitial extends MyCartState {}

class MyCartItemsLoadedInProcess extends MyCartState {}

class MyCartCreatedInProcess extends MyCartState {}

class MyCartCreatedSuccess extends MyCartState {
  final String cartId;

  MyCartCreatedSuccess({this.cartId});

  @override
  List<Object> get props => [cartId];
}

class MyCartCreatedFailure extends MyCartState {
  final String message;

  MyCartCreatedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class MyCartItemsLoadedSuccess extends MyCartState {
  final List<CartItemEntity> cartItems;

  MyCartItemsLoadedSuccess({this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class MyCartItemsLoadedFailure extends MyCartState {
  final String message;

  MyCartItemsLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class MyCartItemAddedInProcess extends MyCartState {}

class MyCartItemAddedSuccess extends MyCartState {}

class MyCartItemAddedFailure extends MyCartState {
  final String message;

  MyCartItemAddedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class MyCartItemUpdatedInProcess extends MyCartState {}

class MyCartItemUpdatedSuccess extends MyCartState {}

class MyCartItemUpdatedFailure extends MyCartState {
  final String message;

  MyCartItemUpdatedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class MyCartItemRemovedInProcess extends MyCartState {}

class MyCartItemRemovedSuccess extends MyCartState {}

class MyCartItemRemovedFailure extends MyCartState {
  final String message;

  MyCartItemRemovedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class MyCartItemsClearedInProcess extends MyCartState {}

class MyCartItemsClearedSuccess extends MyCartState {}

class MyCartItemsClearedFailure extends MyCartState {
  final String message;

  MyCartItemsClearedFailure({this.message});

  @override
  List<Object> get props => [message];
}
