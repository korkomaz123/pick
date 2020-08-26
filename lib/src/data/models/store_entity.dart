import 'package:ciga/src/data/models/index.dart';

class StoreEntity {
  final String id;
  final String name;
  final String imageUrl;
  final List<ProductEntity> products;

  StoreEntity({this.id, this.name, this.products, this.imageUrl});

  StoreEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imageUrl = json['imageUrl'],
        products = json['products'];
}
