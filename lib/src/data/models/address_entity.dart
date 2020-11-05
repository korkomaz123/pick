class AddressEntity {
  final String firstName;
  final String lastName;
  final String addressId;
  final String country;
  final String region;
  final String city;
  final String street;
  final String zipCode;
  final String phoneNumber;
  final String isActive;

  AddressEntity({
    this.firstName,
    this.lastName,
    this.addressId,
    this.country,
    this.region,
    this.city,
    this.street,
    this.zipCode,
    this.phoneNumber,
    this.isActive,
  });

  AddressEntity.fromJson(Map<String, dynamic> json)
      : firstName = json['firstname'],
        lastName = json['lastname'],
        addressId = json['addressId'],
        country = json['country'],
        region = json['region'],
        city = json['city'],
        street = json['street'],
        zipCode = json['zipCode'],
        phoneNumber = json['telephone'],
        isActive = json['isActive'];
}
