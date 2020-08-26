import 'index.dart';

class CategoryEntity {
  final String id;
  final String name;
  final String imageUrl;
  final List<ProductEntity> products;

  CategoryEntity({
    this.id,
    this.name,
    this.imageUrl,
    this.products,
  });

  CategoryEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imageUrl = json['imageUrl'],
        products = json['products'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'products': products,
      };
}
