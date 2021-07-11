class BrandEntity {
  final String entityId;
  final String attributeId;
  final String optionId;
  final String attributeCode;
  final String brandLabel;
  final String sortOrder;
  final String brandThumbnail;
  final String url;
  final int productsCount;
  final int percentage;

  BrandEntity({
    this.entityId,
    this.attributeId,
    this.optionId,
    this.attributeCode,
    this.brandLabel,
    this.sortOrder,
    this.brandThumbnail,
    this.url,
    this.productsCount,
    this.percentage,
  });

  BrandEntity.fromJson(Map<String, dynamic> json)
      : entityId = json['entity_id'],
        attributeId = json['attribute_id'],
        optionId = json['option_id'],
        attributeCode = json['attribute_code'],
        brandLabel = json['brand_label'],
        sortOrder = json['sort_order'],
        brandThumbnail = json['brand_thumbnail'],
        url = json['url'],
        productsCount = json['item_count'],
        percentage = json.containsKey('disPercent') ? json['disPercent'] : 0;
}
