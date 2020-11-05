part of 'my_cart_bloc.dart';

abstract class MyCartEvent extends Equatable {
  const MyCartEvent();

  @override
  List<Object> get props => [];
}

class MyCartItemsLoaded extends MyCartEvent {
  final String cartId;

  MyCartItemsLoaded({this.cartId});

  @override
  List<Object> get props => [cartId];
}
