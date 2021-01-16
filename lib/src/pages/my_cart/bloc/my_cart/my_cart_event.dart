part of 'my_cart_bloc.dart';

abstract class MyCartEvent extends Equatable {
  const MyCartEvent();

  @override
  List<Object> get props => [];
}

class MyCartCreated extends MyCartEvent {
  final ProductModel product;

  MyCartCreated({this.product});

  @override
  List<Object> get props => [product];
}

class MyCartItemsLoaded extends MyCartEvent {
  final String cartId;
  final String lang;

  MyCartItemsLoaded({this.cartId, this.lang});

  @override
  List<Object> get props => [cartId, lang];
}

class MyCartItemAdded extends MyCartEvent {
  final String cartId;
  final ProductModel product;
  final String qty;

  MyCartItemAdded({this.cartId, this.product, this.qty});

  @override
  List<Object> get props => [cartId, product, qty];
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

class CouponCodeApplied extends MyCartEvent {
  final String cartId;
  final String couponCode;

  CouponCodeApplied({this.cartId, this.couponCode});

  @override
  List<Object> get props => [cartId, couponCode];
}

class CouponCodeCancelled extends MyCartEvent {
  final String cartId;
  final String couponCode;

  CouponCodeCancelled({this.cartId, this.couponCode});

  @override
  List<Object> get props => [cartId, couponCode];
}

class MyCartItemsInitialize extends MyCartEvent {}
