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
    if (event is OrderSubmitted) {
      yield* _mapOrderSubmittedToState(
        event.orderDetails,
        event.lang,
      );
    }
  }

  Stream<CheckoutState> _mapOrderSubmittedToState(
    Map<String, dynamic> orderDetails,
    String lang,
  ) async* {
    yield OrderSubmittedInProcess();
    try {
      final result = await _checkoutRepository.placeOrder(orderDetails, lang);
      // print(result);
      if (result['code'] == 'SUCCESS') {
        yield OrderSubmittedSuccess(orderNo: result['orderNo']);
      } else {
        print(result['errorMessage']);
        yield OrderSubmittedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      print('catch');
      print(e.toString());
      yield OrderSubmittedFailure(message: e.toString());
    }
  }
}
