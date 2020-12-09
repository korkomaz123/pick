import 'brand_entity.dart';

class ProductModel {
  final String entityId;
  final String typeId;
  final String sku;
  final String metaKeyword;
  final String description;
  final String shortDescription;
  final String name;
  final String metaDescription;
  final String price;
  final String imageUrl;
  final String hasOptions;
  final String addCartUrl;
  final String productId;
  final String brandLabel;
  final String brandId;
  final BrandEntity brandEntity;

  ProductModel({
    this.entityId,
    this.typeId,
    this.sku,
    this.metaKeyword,
    this.description,
    this.shortDescription,
    this.name,
    this.metaDescription,
    this.price,
    this.imageUrl,
    this.hasOptions,
    this.addCartUrl,
    this.productId,
    this.brandLabel,
    this.brandId,
    this.brandEntity,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : entityId = json['entity_id'],
        typeId = json['type_id'],
        sku = json['sku'],
        metaKeyword = json['meta_keyword'],
        description = json['description'] ?? '',
        shortDescription = json['short_description'] ?? '',
        name = json['name'],
        metaDescription = json['meta_description'],
        price = json['price'] != null
            ? double.parse(json['price']).toStringAsFixed(2)
            : '0.00',
        imageUrl = json['image_url'],
        hasOptions = json['has_options'],
        addCartUrl = json['add_cart_url'],
        productId = json['product_id'],
        brandId = json['brand_id'] ?? '',
        brandLabel = json['brand_label'] == null || json['brand_label'] == 'no'
            ? ''
            : json['brand_label'],
        brandEntity =
            json['brand_entity'] != null && json['brand_entity'].isNotEmpty
                ? BrandEntity.fromJson(json['brand_entity'])
                : BrandEntity();
}
