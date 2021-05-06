class UserEntity {
  final String token;
  final String customerId;
  String firstName;
  String lastName;
  String phoneNumber;
  final String email;
  String profileUrl;
  double balance;

  UserEntity({
    this.token,
    this.customerId,
    this.firstName,
    this.lastName,
    this.email,
    this.profileUrl,
    this.balance,
  });

  UserEntity.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        customerId = json['customer_id'] ?? json['entity_id'],
        firstName = json['firstname'],
        lastName = json['lastname'],
        phoneNumber = json['phoneNumber'],
        email = json['email'],
        profileUrl = json['profileUrl'] ?? '',
        balance = json['balance'] ?? 0;

  Map<String, dynamic> toJson() => {
        'token': token,
        'customerId': customerId,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'profileUrl': profileUrl,
        'balance': balance,
      };
}
