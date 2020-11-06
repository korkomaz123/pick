import 'package:ciga/src/data/models/product_model.dart';

class CartItemEntity {
  final ProductModel product;
  int itemCount;

  CartItemEntity({this.product, this.itemCount});

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = json['product'],
        itemCount = json['itemCount'];
}
