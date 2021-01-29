import 'package:markaa/src/data/models/product_model.dart';

class CartItemEntity {
  final ProductModel product;
  int itemCount;
  int itemCountCanceled;
  int itemCountReturned;
  int returnedStatus;
  int availableCount;
  String itemId;
  double rowPrice;

  CartItemEntity({
    this.product,
    this.itemCount,
    this.itemCountCanceled,
    this.itemCountReturned,
    this.returnedStatus,
    this.availableCount,
    this.itemId,
    this.rowPrice,
  });

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = json['product'],
        itemCount = _getIntValueFromString(json['itemCount']),
        itemCountCanceled = _getIntValueFromString(json['itemCountCanceled']),
        itemCountReturned = _getIntValueFromString(json['itemCountReturned']),
        returnedStatus = _getIntValueFromString(json['returnStatus']),
        availableCount = json['availableCount'],
        itemId = json['itemId'],
        rowPrice = json['rowPrice'] + .0;

  static int _getIntValueFromString(dynamic qty) {
    if (qty != null) {
      double doubleQty = double.parse(qty.toString());
      String intableString = doubleQty.toStringAsFixed(0);
      return int.parse(intableString);
    } else {
      return 0;
    }
  }
}
