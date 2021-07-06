import 'package:markaa/src/utils/services/string_service.dart';

class ShippingMethodEntity {
  final String id;
  final String title;
  final String description;
  final String type;
  final double serviceFees;
  final double minOrderAmount;

  ShippingMethodEntity({
    this.id,
    this.title,
    this.description,
    this.type,
    this.serviceFees,
    this.minOrderAmount,
  });

  ShippingMethodEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'] ?? '',
        type = json['type'] ?? '',
        serviceFees = StringService.roundDouble(json['serviceFees'], 3),
        minOrderAmount = json.containsKey('min_order_amount')
            ? StringService.roundDouble(json['min_order_amount'], 3)
            : 0;
}
