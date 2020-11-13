part of 'shipping_address_bloc.dart';

abstract class ShippingAddressEvent extends Equatable {
  const ShippingAddressEvent();

  @override
  List<Object> get props => [];
}

class ShippingAddressInitialized extends ShippingAddressEvent {}

class ShippingAddressLoaded extends ShippingAddressEvent {
  final String token;

  ShippingAddressLoaded({this.token});

  @override
  List<Object> get props => [token];
}

class ShippingAddressAdded extends ShippingAddressEvent {
  final String token;
  final String firstName;
  final String lastName;
  final String countryId;
  final String region;
  final String city;
  final String streetName;
  final String zipCode;
  final String phone;

  ShippingAddressAdded({
    this.token,
    this.firstName,
    this.lastName,
    this.countryId,
    this.region,
    this.city,
    this.streetName,
    this.zipCode,
    this.phone,
  });

  @override
  List<Object> get props => [
        token,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phone,
      ];
}

class ShippingAddressUpdated extends ShippingAddressEvent {
  final String token;
  final String addressId;
  final String firstName;
  final String lastName;
  final String countryId;
  final String region;
  final String city;
  final String streetName;
  final String zipCode;
  final String phone;
  final String isDefaultBilling;
  final String isDefaultShipping;

  ShippingAddressUpdated({
    this.token,
    this.addressId,
    this.firstName,
    this.lastName,
    this.countryId,
    this.region,
    this.city,
    this.streetName,
    this.zipCode,
    this.phone,
    this.isDefaultBilling,
    this.isDefaultShipping,
  });

  @override
  List<Object> get props => [
        token,
        addressId,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phone,
        isDefaultBilling,
        isDefaultShipping,
      ];
}

class ShippingAddressRemoved extends ShippingAddressEvent {
  final String token;
  final String addressId;

  ShippingAddressRemoved({this.token, this.addressId});

  @override
  List<Object> get props => [token, addressId];
}
