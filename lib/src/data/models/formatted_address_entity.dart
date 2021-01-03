class FormattedAddressEntity {
  final String country;
  final String countryCode;
  final String city;
  final String state;
  final String street;
  final String postalCode;
  final String formattedAddress;

  FormattedAddressEntity({
    this.country,
    this.countryCode,
    this.state,
    this.city,
    this.street,
    this.postalCode,
    this.formattedAddress,
  });

  FormattedAddressEntity.fromJson(Map<String, dynamic> json)
      : country = json['country'],
        countryCode = json['country_code'],
        city = json['city'],
        state = json['state'],
        street = json['street'],
        postalCode = json['postal_code'],
        formattedAddress = json['formatted_address'];
}
