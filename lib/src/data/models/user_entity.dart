class UserEntity {
  final String token;
  final String customerId;
  final String firstName;
  final String lastName;
  final String email;

  UserEntity({
    this.token,
    this.customerId,
    this.firstName,
    this.lastName,
    this.email,
  });

  UserEntity.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        customerId = json['customer_id'] ?? json['entity_id'],
        firstName = json['firstname'],
        lastName = json['lastname'],
        email = json['email'];
}
