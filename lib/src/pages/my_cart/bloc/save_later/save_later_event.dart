part of 'save_later_bloc.dart';

abstract class SaveLaterEvent extends Equatable {
  const SaveLaterEvent();

  @override
  List<Object> get props => [];
}

class SaveLaterItemsLoaded extends SaveLaterEvent {
  final String token;
  final String lang;

  SaveLaterItemsLoaded({this.token, this.lang});

  @override
  List<Object> get props => [token, lang];
}

class SaveLaterItemChanged extends SaveLaterEvent {
  final String token;
  final String productId;
  final String action;
  final int qty;
  final ProductModel product;
  final String itemId;

  SaveLaterItemChanged({
    this.token,
    this.productId,
    this.action,
    this.qty,
    this.product,
    this.itemId,
  });

  @override
  List<Object> get props => [token, productId, action, qty, product, itemId];
}
