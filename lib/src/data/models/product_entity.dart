import 'package:ciga/src/data/models/index.dart';

class ProductEntity {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final double discount;
  final String channel;
  final StoreEntity store;

  ProductEntity({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.discount,
    this.channel,
    this.store,
  });

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        image = json['image'],
        price = json['price'],
        discount = json['discount'],
        channel = json['channel'],
        store = json['store'];
}
