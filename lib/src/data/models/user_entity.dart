class UserEntity {
  final String token;
  final String customerId;
  final String email;
  String firstName;
  String lastName;
  String? phoneNumber;
  String? profileUrl;
  double balance;

  UserEntity({
    required this.token,
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileUrl,
    required this.balance,
  });

  UserEntity.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        customerId = json['customer_id'] ?? json['entity_id'],
        firstName = json['firstname'],
        lastName = json['lastname'],
        phoneNumber = json['phoneNumber'],
        email = json['email'],
        profileUrl = json['profileUrl'] ?? '',
        balance =
            json.containsKey('amount_wallet') && json['amount_wallet'] != null
                ? double.parse(json['amount_wallet'].toString())
                : 0;

  Map<String, dynamic> toJson() => {
        'token': token,
        'customerId': customerId,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'profileUrl': profileUrl,
        'amount_wallet': balance,
      };
}
