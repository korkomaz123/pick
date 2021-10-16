import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';
import 'package:markaa/src/utils/services/string_service.dart';

class CartItemEntity {
  final ProductModel product;
  int itemCount;
  int? itemCountCanceled;
  int? itemCountReturned;
  int? returnedStatus;
  int availableCount;
  String itemId;
  double rowPrice;

  CartItemEntity({
    required this.product,
    required this.itemCount,
    this.itemCountCanceled,
    this.itemCountReturned,
    this.returnedStatus,
    required this.availableCount,
    required this.itemId,
    required this.rowPrice,
  });

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = json['product'],
        itemCount = _getIntValueFromString(json['itemCount']),
        itemCountCanceled = _getIntValueFromString(json['itemCountCanceled']),
        itemCountReturned = _getIntValueFromString(json['itemCountReturned']),
        returnedStatus = _getIntValueFromString(json['returnStatus']),
        availableCount = json['availableCount'],
        itemId = json['itemId'],
        rowPrice = _getRowPrice(
            _getIntValueFromString(json['itemCount']), json['product']);

  static int _getIntValueFromString(dynamic qty) {
    if (qty != null) {
      double doubleQty = double.parse(qty.toString());
      String intableString = doubleQty.toStringAsFixed(0);
      return int.parse(intableString);
    } else {
      return 0;
    }
  }

  static double _getRowPrice(int itemCount, ProductModel product) {
    double rowPrice = itemCount * StringService.roundDouble(product.price, 3);
    return NumericService.roundDouble(rowPrice, 3);
  }
}
