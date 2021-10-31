class PaymentMethodEntity {
  final String id;
  final String title;

  PaymentMethodEntity({required this.id, required this.title});

  PaymentMethodEntity.fromJson(Map<String, dynamic> json)
      : id = json['value'],
        title = json['label'];
}
