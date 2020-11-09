class PaymentMethodEntity {
  final String id;
  final String title;

  PaymentMethodEntity({this.id, this.title});

  PaymentMethodEntity.fromJson(Map<String, dynamic> json)
      : id = json['value'],
        title = json['label'];
}
