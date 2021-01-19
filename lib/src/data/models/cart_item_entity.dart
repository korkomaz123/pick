import 'package:markaa/src/data/models/product_model.dart';

class CartItemEntity {
  final ProductModel product;
  int itemCount;
  int itemCountCanceled;
  int availableCount;
  String itemId;
  double rowPrice;

  CartItemEntity({
    this.product,
    this.itemCount,
    this.itemCountCanceled,
    this.availableCount,
    this.itemId,
    this.rowPrice,
  });

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = json['product'],
        itemCount = _getIntValueFromString(json['itemCount']),
        itemCountCanceled = _getIntValueFromString(json['itemCountCanceled'] ?? '0.00'),
        availableCount = json['availableCount'],
        itemId = json['itemId'],
        rowPrice = json['rowPrice'] + .0;

  static int _getIntValueFromString(String qty) {
    double doubleQty = double.parse(qty);
    String intableString = doubleQty.toStringAsFixed(0);
    return int.parse(intableString);
  }
}
