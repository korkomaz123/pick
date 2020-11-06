import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/order_entity.dart';
import 'package:ciga/src/pages/my_account/order_history/bloc/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({@required OrderRepository orderRepository})
      : assert(orderRepository != null),
        _orderRepository = orderRepository,
        super(OrderInitial());

  final OrderRepository _orderRepository;

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is OrderHistoryLoaded) {
      yield* _mapOrderHistoryLoadedToState(event.token);
    }
  }

  Stream<OrderState> _mapOrderHistoryLoadedToState(String token) async* {
    yield OrderHistoryLoadedInProcess();
    try {
      final result = await _orderRepository.getOrderHistory(token);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> ordersList = result['orders'];
        List<OrderEntity> orders = [];
        for (int i = 0; i < ordersList.length; i++) {
          orders.add(OrderEntity.fromJson(ordersList[i]));
        }
        yield OrderHistoryLoadedSuccess(orders: orders);
      } else {
        yield OrderHistoryLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield OrderHistoryLoadedFailure(message: e.toString());
    }
  }
}
