import 'brand_entity.dart';

class ProductModel {
  String parentId;
  String wishlistItemId;
  String entityId;
  String typeId;
  String sku;
  String metaKeyword;
  String description;
  String shortDescription;
  String name;
  String metaDescription;
  String price;
  String imageUrl;
  String hasOptions;
  String addCartUrl;
  String productId;
  BrandEntity brandEntity;
  int stockQty;
  int qtySaveForLater;
  Map<String, dynamic> options;

  ProductModel({
    this.parentId,
    this.wishlistItemId,
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
    this.brandEntity,
    this.stockQty,
    this.qtySaveForLater,
    this.options,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : parentId = json.containsKey('parent_id') && json['parent_id'] != null
            ? json['parent_id']
            : '',
        wishlistItemId = json.containsKey('wishlist_item_id')
            ? json['wishlist_item_id']
            : null,
        entityId = json['entity_id'],
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
        brandEntity = json['brand_id'] != null
            ? BrandEntity(
                optionId: json['brand_id'],
                brandThumbnail: json['brand_thumbnail'],
                brandLabel: json['brand_label'],
              )
            : null,
        stockQty = json['stockQty'],
        qtySaveForLater = json.containsKey('qty_saveforlater')
            ? double.parse(json['qty_saveforlater']).ceil()
            : 0,
        options =
            json.containsKey('options') ? _getOptions(json['options']) : null;

  static Map<String, dynamic> _getOptions(List<dynamic> list) {
    Map<String, dynamic> options = {};
    for (var item in list) {
      options[item['attribute_id']] = item['attribute_options']['option_value'];
    }
    return options;
  }
}
