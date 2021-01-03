class CategoryEntity {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<CategoryEntity> subCategories;

  CategoryEntity({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.subCategories,
  });

  CategoryEntity.fromJson(Map<String, dynamic> json)
      : id = json['category_id'],
        name = json['category_name'],
        description = json['category_description'],
        imageUrl = json['category_image'],
        subCategories = _getSubCategories(json['subcategories']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'category_name': name,
        'category_description'
            'category_image': imageUrl,
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
