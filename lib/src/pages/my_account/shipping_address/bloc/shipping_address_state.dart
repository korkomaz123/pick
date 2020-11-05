part of 'shipping_address_bloc.dart';

abstract class ShippingAddressState extends Equatable {
  const ShippingAddressState();

  @override
  List<Object> get props => [];
}

class ShippingAddressInitial extends ShippingAddressState {}

class ShippingAddressLoadedInProcess extends ShippingAddressState {}

class ShippingAddressLoadedSuccess extends ShippingAddressState {
  final List<AddressEntity> addresses;

  ShippingAddressLoadedSuccess({this.addresses});

  @override
  List<Object> get props => [addresses];
}

class ShippingAddressLoadedFailure extends ShippingAddressState {
  final String message;

  ShippingAddressLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class ShippingAddressAddedInProcess extends ShippingAddressState {}

class ShippingAddressAddedSuccess extends ShippingAddressState {}

class ShippingAddressAddedFailure extends ShippingAddressState {
  final String message;

  ShippingAddressAddedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class ShippingAddressRemovedInProcess extends ShippingAddressState {}

class ShippingAddressRemovedSuccess extends ShippingAddressState {}

class ShippingAddressRemovedFailure extends ShippingAddressState {
  final String message;

  ShippingAddressRemovedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class ShippingAddressUpdatedInProcess extends ShippingAddressState {}

class ShippingAddressUpdatedSuccess extends ShippingAddressState {}

class ShippingAddressUpdatedFailure extends ShippingAddressState {
  final String message;

  ShippingAddressUpdatedFailure({this.message});

  @override
  List<Object> get props => [message];
}
