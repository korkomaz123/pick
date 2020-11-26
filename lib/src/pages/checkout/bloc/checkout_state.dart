part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class OrderSubmittedInProcess extends CheckoutState {}

class OrderSubmittedSuccess extends CheckoutState {
  final String orderNo;

  OrderSubmittedSuccess({this.orderNo});

  @override
  List<Object> get props => [orderNo];
}

class OrderSubmittedFailure extends CheckoutState {
  final String message;

  OrderSubmittedFailure({this.message});

  @override
  List<Object> get props => [message];
}
