class SummerCollectionEntity {
  final String brandLogo;
  final String brandLabel;
  final String categoryName;
  final String categoryId;
  final String brandId;
  final String productId;
  final String imageUrl;

  SummerCollectionEntity({
    this.categoryId,
    this.brandLogo,
    this.brandId,
    this.productId,
    this.categoryName,
    this.brandLabel,
    this.imageUrl,
  });

  SummerCollectionEntity.fromJson(Map<String, dynamic> json)
      : categoryId = json['category_id'],
        brandId = json['brand_id'],
        brandLogo = json['brand_thumbnail'],
        productId = json['product_id'],
        categoryName = json['category_name'],
        brandLabel = json['brand_label'],
        imageUrl = json['image'];
}
