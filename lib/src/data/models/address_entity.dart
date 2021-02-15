class AddressEntity {
  final String title;
  final String firstName;
  final String lastName;
  final String email;
  final String addressId;
  final String country;
  final String countryId;
  final String region;
  final String city;
  final String street;
  final String company;
  final String postCode;
  final String phoneNumber;
  final int defaultBillingAddress;
  final int defaultShippingAddress;

  AddressEntity({
    this.title,
    this.firstName,
    this.lastName,
    this.email,
    this.addressId,
    this.country,
    this.countryId,
    this.region,
    this.city,
    this.street,
    this.company,
    this.postCode,
    this.phoneNumber,
    this.defaultBillingAddress,
    this.defaultShippingAddress,
  });

  AddressEntity.fromJson(Map<String, dynamic> json)
      : title = json['prefix'] ?? '',
        firstName = json['firstname'],
        lastName = json['lastname'],
        email = json['email'],
        addressId = json['entity_id'],
        country = json['country_name'],
        countryId = json['country_id'],
        region = json['region'] ?? '',
        city = json['city'] ?? '',
        street = json['street'],
        postCode = json['postcode'],
        company = json['company'] ?? '',
        phoneNumber = json['telephone'],
        defaultBillingAddress = json['DefaultBillingAddress'],
        defaultShippingAddress = json['DefaultShippingAddress'];
}
