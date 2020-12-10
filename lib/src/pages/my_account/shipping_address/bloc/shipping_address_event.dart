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
  final String title;
  final String firstName;
  final String lastName;
  final String countryId;
  final String region;
  final String city;
  final String streetName;
  final String zipCode;
  final String phone;
  final String company;
  final String email;

  ShippingAddressAdded({
    this.token,
    this.title,
    this.firstName,
    this.lastName,
    this.countryId,
    this.region,
    this.city,
    this.streetName,
    this.zipCode,
    this.phone,
    this.company,
    this.email,
  });

  @override
  List<Object> get props => [
        token,
        title,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phone,
        company,
        email,
      ];
}

class ShippingAddressUpdated extends ShippingAddressEvent {
  final String token;
  final String title;
  final String addressId;
  final String firstName;
  final String lastName;
  final String countryId;
  final String region;
  final String city;
  final String streetName;
  final String zipCode;
  final String phone;
  final String company;
  final String email;
  final String isDefaultBilling;
  final String isDefaultShipping;

  ShippingAddressUpdated({
    this.token,
    this.title,
    this.addressId,
    this.firstName,
    this.lastName,
    this.countryId,
    this.region,
    this.city,
    this.streetName,
    this.zipCode,
    this.phone,
    this.company,
    this.email,
    this.isDefaultBilling,
    this.isDefaultShipping,
  });

  @override
  List<Object> get props => [
        token,
        title,
        addressId,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phone,
        company,
        email,
        isDefaultBilling,
        isDefaultShipping,
      ];
}

class DefaultShippingAddressUpdated extends ShippingAddressEvent {
  final String token;
  final String title;
  final String addressId;
  final String firstName;
  final String lastName;
  final String countryId;
  final String region;
  final String city;
  final String streetName;
  final String zipCode;
  final String phone;
  final String email;
  final String company;
  final String isDefaultBilling;
  final String isDefaultShipping;

  DefaultShippingAddressUpdated({
    this.token,
    this.title,
    this.addressId,
    this.firstName,
    this.lastName,
    this.countryId,
    this.region,
    this.city,
    this.streetName,
    this.zipCode,
    this.phone,
    this.email,
    this.company,
    this.isDefaultBilling,
    this.isDefaultShipping,
  });

  @override
  List<Object> get props => [
        token,
        title,
        addressId,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phone,
        email,
        company,
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
