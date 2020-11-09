class AddressEntity {
  final String firstName;
  final String lastName;
  final String addressId;
  final String country;
  final String countryId;
  final String region;
  final String city;
  final String street;
  final String zipCode;
  final String phoneNumber;
  final int defaultBillingAddress;
  final int defaultShippingAddress;

  AddressEntity({
    this.firstName,
    this.lastName,
    this.addressId,
    this.country,
    this.countryId,
    this.region,
    this.city,
    this.street,
    this.zipCode,
    this.phoneNumber,
    this.defaultBillingAddress,
    this.defaultShippingAddress,
  });

  AddressEntity.fromJson(Map<String, dynamic> json)
      : firstName = json['firstname'],
        lastName = json['lastname'],
        addressId = json['entity_id'],
        country = json['country_name'],
        countryId = json['country_id'],
        region = json['region'],
        city = json['city'],
        street = json['street'],
        zipCode = json['postcode'],
        phoneNumber = json['telephone'],
        defaultBillingAddress = json['DefaultBillingAddress'],
        defaultShippingAddress = json['DefaultShippingAddress'];
}
