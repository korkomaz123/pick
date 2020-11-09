import 'package:ciga/src/data/models/product_model.dart';

class CartItemEntity {
  final ProductModel product;
  int itemCount;
  String itemId;
  int rowPrice;

  CartItemEntity({this.product, this.itemCount, this.itemId, this.rowPrice});

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = json['product'],
        itemCount = _getIntValueFromString(json['qty']),
        itemId = json['item_id'],
        rowPrice = json['row_price'];

  static int _getIntValueFromString(String qty) {
    double doubleQty = double.parse(qty);
    String intableString = doubleQty.toStringAsFixed(0);
    return int.parse(intableString);
  }
}
