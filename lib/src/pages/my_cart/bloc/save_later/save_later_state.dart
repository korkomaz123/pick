part of 'save_later_bloc.dart';

abstract class SaveLaterState extends Equatable {
  const SaveLaterState();

  @override
  List<Object> get props => [];
}

class SaveLaterInitial extends SaveLaterState {}

class SaveLaterItemsLoadedInProcess extends SaveLaterState {}

class SaveLaterItemsLoadedSuccess extends SaveLaterState {
  final List<ProductModel> items;

  SaveLaterItemsLoadedSuccess({this.items});

  @override
  List<Object> get props => [items];
}

class SaveLaterItemsLoadedFailure extends SaveLaterState {
  final String message;

  SaveLaterItemsLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class SaveLaterItemChangedInProcess extends SaveLaterState {}

class SaveLaterItemChangedSuccess extends SaveLaterState {
  final ProductModel product;
  final String action;
  final String itemId;

  SaveLaterItemChangedSuccess({this.product, this.action, this.itemId});

  @override
  List<Object> get props => [product, action, itemId];
}

class SaveLaterItemChangedFailure extends SaveLaterState {
  final String message;

  SaveLaterItemChangedFailure({this.message});

  @override
  List<Object> get props => [message];
}
