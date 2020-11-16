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
        subCategories = _getSubCategories(json['subcategories']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      };

  static List<CategoryEntity> _getSubCategories(List<dynamic> subCategories) {
    List<CategoryEntity> categories = [];
    if (subCategories != null && subCategories.isNotEmpty) {
      for (int i = 0; i < subCategories.length; i++) {
        categories.add(CategoryEntity.fromJson(subCategories[i]));
      }
    }
    return categories;
  }
}
