part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderHistoryLoadedInProcess extends OrderState {}

class OrderHistoryLoadedSuccess extends OrderState {
  final List<OrderEntity> orders;

  OrderHistoryLoadedSuccess({this.orders});

  @override
  List<Object> get props => [orders];
}

class OrderHistoryLoadedFailure extends OrderState {
  final String message;

  OrderHistoryLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class OrderCancelledInProcess extends OrderState {}

class OrderCancelledSuccess extends OrderState {}

class OrderCancelledFailure extends OrderState {
  final String message;

  OrderCancelledFailure({this.message});

  @override
  List<Object> get props => [message];
}
