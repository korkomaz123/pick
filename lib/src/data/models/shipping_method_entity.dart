class ShippingMethodEntity {
  final String id;
  final String title;
  final String description;
  final String type;
  final double serviceFees;

  ShippingMethodEntity({
    this.id,
    this.title,
    this.description,
    this.type,
    this.serviceFees,
  });

  static double _getFeesFromStringValue(String value) {
    if (value != null) {
      double doubleValue = double.parse(value);
      return doubleValue;
    } else {
      return .0;
    }
  }

  ShippingMethodEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'] ?? '',
        type = json['type'] ?? '',
        serviceFees = _getFeesFromStringValue(json['serviceFees']);
}
