import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/review_entity.dart';

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
  final String beforePrice;
  final int discount;
  final String imageUrl;
  final String hasOptions;
  final String addCartUrl;
  final String productId;
  final List<dynamic> gallery;
  final List<ReviewEntity> reviews;
  final BrandEntity brandEntity;
  final int stockQty;
  final Map<String, dynamic> configurable;
  final List<ProductModel> variants;

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
    this.beforePrice,
    this.discount,
    this.imageUrl,
    this.hasOptions,
    this.addCartUrl,
    this.productId,
    this.gallery,
    this.reviews,
    this.brandEntity,
    this.stockQty,
    this.configurable,
    this.variants,
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
        price = json['special_price'] != null
            ? double.parse(json['special_price']).toStringAsFixed(3)
            : json['price'] != null
                ? double.parse(json['price']).toStringAsFixed(3)
                : null,
        beforePrice = json['price'] != null ? double.parse(json['price']).toStringAsFixed(3) : null,
        discount = _getDiscount(json['special_price'] != null ? json['special_price'] : json['price'], json['price']),
        imageUrl = json['image_url'],
        hasOptions = json['has_options'],
        addCartUrl = json['add_cart_url'],
        productId = json['product_id'],
        gallery = json['gallery'],
        reviews = json['reviews'],
        brandEntity = json['brand_id'] != null
            ? BrandEntity(
                optionId: json['brand_id'],
                brandLabel: json['brand_label'],
                brandThumbnail: json['brand_thumbnail'],
              )
            : null,
        stockQty = json['stockQty'],
        configurable = json['configurable'],
        variants = _getVariants(json['child_products']);

  static List<ProductModel> _getVariants(List<dynamic> list) {
    List<ProductModel> variants = [];
    if (list != null) {
      for (var item in list) {
        variants.add(ProductModel.fromJson(item));
      }
    }
    return variants;
  }

  ProductEntity.fronProduct(ProductModel product)
      : entityId = product.entityId,
        typeId = product.typeId,
        sku = product.sku,
        inStock = product.stockQty > 0,
        metaKeyword = product.metaKeyword,
        description = product.description ?? '',
        shortDescription = product.shortDescription ?? '',
        name = product.name,
        metaDescription = product.metaDescription,
        price = product.price,
        beforePrice = product.price != null ? double.parse(product.price).toStringAsFixed(3) : null,
        discount = _getDiscount(product.beforePrice != null ? product.beforePrice : product.price, product.price),
        imageUrl = product.imageUrl,
        hasOptions = product.hasOptions,
        addCartUrl = product.addCartUrl,
        productId = product.productId,
        gallery = [product.imageUrl],
        stockQty = product.stockQty,
        reviews = null,
        brandEntity = null,
        configurable = null,
        variants = _getVariants(null);

  static int _getDiscount(String afterPriceString, String beforePriceString) {
    double afterPrice = afterPriceString != null ? double.parse(afterPriceString) : 0;
    double beforePrice = beforePriceString != null ? double.parse(beforePriceString) : 0;
    if (beforePrice == 0) {
      return 0;
    }
    return (((beforePrice - afterPrice) / beforePrice * 100) + 0.5).floor();
  }
}
