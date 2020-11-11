class CategoryEntity {
  final String id;
  final String name;
  final String imageUrl;
  final List<CategoryEntity> subCategories;

  CategoryEntity({
    this.id,
    this.name,
    this.imageUrl,
    this.subCategories,
  });

  CategoryEntity.fromJson(Map<String, dynamic> json)
      : id = json['category_id'],
        name = json['category_name'],
        imageUrl = json['category_image'],
        subCategories = json['subCategories'] ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      };
}
