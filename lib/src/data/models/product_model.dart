import 'package:markaa/src/utils/services/string_service.dart';

import 'brand_entity.dart';

class ProductModel {
  String? parentId;
  String? wishlistItemId;
  String entityId;
  String? typeId;
  String? sku;
  String? metaKeyword;
  String? description;
  String? shortDescription;
  String name;
  String? metaDescription;
  String price;
  String? beforePrice;
  int? discount;
  String imageUrl;
  String? hasOptions;
  String? addCartUrl;
  String productId;
  BrandEntity? brandEntity;
  int? stockQty;
  int? qtySaveForLater;
  Map<String, dynamic>? options;
  bool? isDeal;
  List<dynamic>? gallery;
  List<dynamic>? categories;
  List<dynamic>? subCategories;
  List<dynamic>? parentCategories;

  ProductModel({
    this.parentId,
    this.wishlistItemId,
    required this.entityId,
    this.typeId,
    this.sku,
    this.metaKeyword,
    this.description,
    this.shortDescription,
    required this.name,
    this.metaDescription,
    required this.price,
    this.beforePrice,
    required this.imageUrl,
    this.hasOptions,
    this.addCartUrl,
    required this.productId,
    this.brandEntity,
    this.stockQty,
    this.qtySaveForLater,
    this.options,
    this.isDeal,
    this.gallery,
    this.categories,
    this.subCategories,
    this.parentCategories,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : parentId = json.containsKey('parent_id') && json['parent_id'] != null ? json['parent_id'] : '',
        wishlistItemId = json.containsKey('wishlist_item_id') ? json['wishlist_item_id'] : null,
        entityId = json['entity_id'],
        typeId = json['type_id'],
        sku = json['sku'],
        metaKeyword = json['meta_keyword'],
        description = json['description'] ?? '',
        shortDescription = json['short_description'] ?? '',
        name = json['name'],
        metaDescription = json['meta_description'],
        price = json['special_price'] != null
            ? StringService.roundString(json['special_price'], 3)
            : StringService.roundString(json['price'], 3),
        beforePrice = json['price'] != null ? StringService.roundString(json['price'], 3) : null,
        discount = _getDiscount(json['special_price'] != null ? json['special_price'] : json['price'], json['price']),
        imageUrl = json['image_url'],
        hasOptions = json['has_options'],
        addCartUrl = json['add_cart_url'],
        productId = json['product_id'],
        brandEntity = json['brand_id'] != null
            ? BrandEntity(
                optionId: json['brand_id'],
                brandThumbnail: json['brand_thumbnail'],
                brandLabel: json['brand_label'],
                brandImage: json['brand_thumbnail'],
              )
            : null,
        stockQty = json['stockQty'],
        qtySaveForLater =
            json.containsKey('qty_saveforlater') ? double.parse(json['qty_saveforlater'].toString()).ceil() : 0,
        options = json.containsKey('options') ? _getOptions(json['options']) : null,
        isDeal = json['sale'] == '1',
        gallery = json.containsKey('gallery') ? json['gallery'] : [],
        categories = json.containsKey('categories') ? json['categories'] : [],
        subCategories = json.containsKey('subcategories') ? json['subcategories'] : [],
        parentCategories = json.containsKey('parentcategories') ? json['parentcategories'] : [];

  static Map<String, dynamic> _getOptions(List<dynamic> list) {
    Map<String, dynamic> options = {};
    for (var item in list) {
      if (item['attribute_options'] != null) options[item['attribute_id']] = item['attribute_options']['option_value'];
    }
    return options;
  }

  static int _getDiscount(String? afterPriceString, String? beforePriceString) {
    if (afterPriceString == null) afterPriceString = '0';
    if (beforePriceString == null) beforePriceString = '0';
    double afterPrice = double.parse(afterPriceString);
    double beforePrice = double.parse(beforePriceString);
    if (beforePrice == 0) {
      return 0;
    }
    return (((beforePrice - afterPrice) / beforePrice * 100) + 0.5).floor();
  }
}

List<ProductModel> getProductList(List<dynamic> list) {
  List<ProductModel> products = [];
  for (var item in list) {
    products.add(ProductModel.fromJson(item));
  }
  return products;
}
