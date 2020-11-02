import 'index.dart';

class CategoryEntity {
  final String id;
  final String name;
  final String imageUrl;
  final List<ProductEntity> products;
  final List<CategoryEntity> subCategories;

  CategoryEntity({
    this.id,
    this.name,
    this.imageUrl,
    this.products,
    this.subCategories,
  });

  CategoryEntity.fromJson(Map<String, dynamic> json)
      : id = json['category_id'],
        name = json['category_name'],
        imageUrl = json['category_image'],
        products = json['products'] ?? [],
        subCategories = json['subCategories'] ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'products': products,
      };
}
