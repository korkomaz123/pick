import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/review_entity.dart';

class ProductEntity {
  final String entityId;
  final String typeId;
  final String sku;
  final bool inStock;
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
  final List<dynamic> gallery;
  final List<ReviewEntity> reviews;
  final BrandEntity brandEntity;
  final int stockQty;

  ProductEntity({
    this.entityId,
    this.typeId,
    this.sku,
    this.inStock,
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
    this.gallery,
    this.reviews,
    this.brandEntity,
    this.stockQty,
  });

  ProductEntity.fromJson(Map<String, dynamic> json)
      : entityId = json['entity_id'],
        typeId = json['type_id'],
        sku = json['sku'],
        inStock = json['in_stock'],
        metaKeyword = json['meta_keyword'],
        description = json['description'] ?? '',
        shortDescription = json['short_description'] ?? '',
        name = json['name'],
        metaDescription = json['meta_description'],
        price = double.parse(json['price']).toStringAsFixed(2),
        imageUrl = json['image_url'],
        hasOptions = json['has_options'],
        addCartUrl = json['add_cart_url'],
        productId = json['product_id'],
        brandLabel = json['brand_label'] == 'no' ? '' : json['brand_label'],
        gallery = json['gallery'],
        reviews = json['reviews'],
        brandEntity =
            json['brand_entity'] != null && json['brand_entity'] != null
                ? BrandEntity.fromJson(json['brand_entity'])
                : BrandEntity(),
        stockQty = json['stockQty'];
}
