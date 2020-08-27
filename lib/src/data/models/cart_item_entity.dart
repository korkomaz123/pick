import 'package:ciga/src/data/models/index.dart';

class CartItemEntity {
  final ProductEntity product;
  int itemCount;

  CartItemEntity({this.product, this.itemCount});

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = json['product'],
        itemCount = json['itemCount'];
}
