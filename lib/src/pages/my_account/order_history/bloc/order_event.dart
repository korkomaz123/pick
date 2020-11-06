part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderHistoryLoaded extends OrderEvent {
  final String token;

  OrderHistoryLoaded({this.token});

  @override
  List<Object> get props => [token];
}
