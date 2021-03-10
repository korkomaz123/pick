part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class TapPaymentCheckout extends CheckoutEvent {
  final Map<String, dynamic> data;
  final String lang;

  TapPaymentCheckout({this.data, this.lang});

  @override
  List<Object> get props => [data, lang];
}
