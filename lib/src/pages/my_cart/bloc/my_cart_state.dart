part of 'my_cart_bloc.dart';

abstract class MyCartState extends Equatable {
  const MyCartState();

  @override
  List<Object> get props => [];
}

class MyCartInitial extends MyCartState {}

class MyCartItemsLoadedInProcess extends MyCartState {}

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
