part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class TapPaymentCheckoutInProcess extends CheckoutState {}

class TapPaymentCheckoutSuccess extends CheckoutState {
  final String url;

  TapPaymentCheckoutSuccess({this.url});

  @override
  List<Object> get props => [url];
}

class TapPaymentCheckoutFailure extends CheckoutState {
  final String message;

  TapPaymentCheckoutFailure({this.message});

  @override
  List<Object> get props => [message];
}
