part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class OrderSubmitted extends CheckoutEvent {
  final Map<String, dynamic> orderDetails;
  final String lang;

  OrderSubmitted({this.orderDetails, this.lang});

  @override
  List<Object> get props => [orderDetails, lang];
}
