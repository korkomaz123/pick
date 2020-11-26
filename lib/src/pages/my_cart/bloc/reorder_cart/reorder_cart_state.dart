part of 'reorder_cart_bloc.dart';

abstract class ReorderCartState extends Equatable {
  const ReorderCartState();

  @override
  List<Object> get props => [];
}

class ReorderCartInitial extends ReorderCartState {}

class ReorderCartItemsLoadedInProcess extends ReorderCartState {}

class ReorderCartItemsLoadedSuccess extends ReorderCartState {
  final List<CartItemEntity> cartItems;

  ReorderCartItemsLoadedSuccess({this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class ReorderCartItemsLoadedFailure extends ReorderCartState {
  final String message;

  ReorderCartItemsLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class ReorderCartItemRemovedInProcess extends ReorderCartState {}

class ReorderCartItemRemovedSuccess extends ReorderCartState {}

class ReorderCartItemRemovedFailure extends ReorderCartState {
  final String message;

  ReorderCartItemRemovedFailure({this.message});

  @override
  List<Object> get props => [message];
}
