class AddressEntity {
  String title;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String addressId;
  String country;
  String countryId;
  String region;
  String regionId;
  String city;
  String street;
  String company;
  String postCode;
  String phoneNumber;
  int defaultBillingAddress;
  int defaultShippingAddress;

  AddressEntity({
    this.title,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.addressId,
    this.country,
    this.countryId,
    this.region,
    this.regionId,
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
        fullName = json['firstname'] + " " + json['lastname'],
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

  Map<String, dynamic> toJson() => {
        'entity_id': addressId ?? '',
        'addressId': addressId ?? '',
        'customer_address_id': addressId ?? '',
        'prefix': title ?? '',
        'firstname': fullName != null && fullName.isNotEmpty ? fullName.split(' ')[0] : firstName,
        'lastname': fullName != null && fullName.isNotEmpty ? fullName.split(' ')[1] : lastName,
        'fullName': fullName,
        'country_name': country,
        'country_id': countryId,
        'region': regionId,
        'city': city,
        'street': street,
        'post_code': postCode,
        'telephone': phoneNumber,
        'company': company,
        'email': email,
        'isdefaultbilling': '$defaultBillingAddress',
        'isdefaultshipping': '$defaultShippingAddress',
      };
}
