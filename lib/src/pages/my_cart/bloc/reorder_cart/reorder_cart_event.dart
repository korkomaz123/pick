part of 'reorder_cart_bloc.dart';

abstract class ReorderCartEvent extends Equatable {
  const ReorderCartEvent();

  @override
  List<Object> get props => [];
}

class ReorderCartItemsLoaded extends ReorderCartEvent {
  final String reorderCartId;
  final String lang;

  ReorderCartItemsLoaded({this.reorderCartId, this.lang});

  @override
  List<Object> get props => [reorderCartId, lang];
}

class ReorderCartItemRemoved extends ReorderCartEvent {
  final String cartId;
  final String itemId;

  ReorderCartItemRemoved({this.cartId, this.itemId});

  @override
  List<Object> get props => [cartId, itemId];
}
