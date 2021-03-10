import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'checkout_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({@required CheckoutRepository checkoutRepository})
      : assert(checkoutRepository != null),
        _checkoutRepository = checkoutRepository,
        super(CheckoutInitial());

  final CheckoutRepository _checkoutRepository;

  @override
  Stream<CheckoutState> mapEventToState(
    CheckoutEvent event,
  ) async* {
    if (event is TapPaymentCheckout) {
      yield* _mapTapPaymentCheckoutToState(event.data, event.lang);
    }
  }

  Stream<CheckoutState> _mapTapPaymentCheckoutToState(
    Map<String, dynamic> data,
    String lang,
  ) async* {
    yield TapPaymentCheckoutInProcess();
    try {
      final result = await _checkoutRepository.tapPaymentCheckout(data, lang);
      print(result);
      yield TapPaymentCheckoutSuccess(url: result['transaction']['url']);
    } catch (e) {
      print(e.toString());
      yield TapPaymentCheckoutFailure(message: e.toString());
    }
  }
}
