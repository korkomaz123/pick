part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderHistoryLoaded extends OrderEvent {
  final String token;
  final String lang;

  OrderHistoryLoaded({this.token, this.lang});

  @override
  List<Object> get props => [token, lang];
}

class OrderCancelled extends OrderEvent {
  final String orderId;
  final List<Map<String, dynamic>> items;
  final String reason;
  final String additionalInfo;
  final Uint8List imageForProduct;
  final String imageName;

  OrderCancelled({
    this.orderId,
    this.items,
    this.reason,
    this.additionalInfo,
    this.imageForProduct,
    this.imageName,
  });

  @override
  List<Object> get props => [
        orderId,
        items,
        reason,
        additionalInfo,
        imageForProduct,
        imageName,
      ];
}
