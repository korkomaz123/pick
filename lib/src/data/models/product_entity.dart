import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/review_entity.dart';
import 'package:markaa/src/utils/services/string_service.dart';

import 'product_specification.dart';

class ProductEntity {
  final String entityId;
  final String typeId;
  final String sku;
  final bool inStock;
  final String metaKeyword;
  final String description;
  final String? fullDescription;
  final String? shortDescription;
  final String name;
  final String? metaDescription;
  final String price;
  final String? beforePrice;
  final int discount;
  final String imageUrl;
  final String? hasOptions;
  final String? addCartUrl;
  final String productId;
  final List<dynamic>? gallery;
  final List<ReviewEntity>? reviews;
  final BrandEntity? brandEntity;
  final int stockQty;
  final Map<String, dynamic>? configurable;
  final List<ProductModel>? variants;
  final List<Specification>? specification;
  final bool isDeal;
  final List<dynamic>? categories;
  final List<dynamic>? subCategories;
  final List<dynamic>? parentCategories;

  ProductEntity({
    required this.entityId,
    this.specification,
    required this.typeId,
    required this.sku,
    required this.inStock,
    required this.metaKeyword,
    required this.description,
    this.fullDescription,
    this.shortDescription,
    required this.name,
    this.metaDescription,
    required this.price,
    this.beforePrice,
    required this.discount,
    required this.imageUrl,
    this.hasOptions,
    this.addCartUrl,
    required this.productId,
    this.gallery,
    this.reviews,
    this.brandEntity,
    required this.stockQty,
    this.configurable,
    this.variants,
    required this.isDeal,
    this.categories,
    this.subCategories,
    this.parentCategories,
  });

  ProductEntity copyWith({
    entityId,
    typeId,
    sku,
    inStock,
    metaKeyword,
    description,
    fullDescription,
    shortDescription,
    name,
    specification,
    metaDescription,
    price,
    beforePrice,
    discount,
    imageUrl,
    hasOptions,
    addCartUrl,
    productId,
    gallery,
    reviews,
    brandEntity,
    stockQty,
    configurable,
    variants,
    isDeal,
    categories,
    subCategories,
    parentCategories,
  }) =>
      ProductEntity(
        entityId: entityId ?? this.entityId,
        typeId: typeId ?? this.typeId,
        sku: sku ?? this.sku,
        inStock: inStock ?? this.inStock,
        metaKeyword: metaKeyword ?? this.metaKeyword,
        description: description ?? this.description,
        fullDescription: fullDescription ?? this.fullDescription,
        shortDescription: shortDescription ?? this.shortDescription,
        name: name ?? this.name,
        metaDescription: metaDescription ?? this.metaDescription,
        price: price ?? this.price,
        beforePrice: beforePrice ?? this.beforePrice,
        discount: discount ?? this.discount,
        imageUrl: imageUrl ?? this.imageUrl,
        hasOptions: hasOptions ?? this.hasOptions,
        addCartUrl: addCartUrl ?? this.addCartUrl,
        productId: productId ?? this.productId,
        specification: specification ?? this.specification,
        gallery: gallery ?? this.gallery,
        reviews: reviews ?? this.reviews,
        brandEntity: brandEntity ?? this.brandEntity,
        stockQty: stockQty ?? this.stockQty,
        configurable: configurable ?? this.configurable,
        variants: variants ?? this.variants,
        isDeal: isDeal ?? this.isDeal,
        categories: categories ?? this.categories,
        subCategories: subCategories ?? this.subCategories,
        parentCategories: parentCategories ?? this.parentCategories,
      );

  ProductEntity.fromJson(Map<String, dynamic> json)
      : entityId = json['entity_id'],
        typeId = json['type_id'],
        sku = json['sku'],
        inStock = json['in_stock'],
        metaKeyword = json['meta_keyword'] ?? '',
        description = json['description'] ?? '',
        fullDescription = json['full_description'] ?? '',
        shortDescription = json['short_description'] ?? '',
        name = json['name'],
        metaDescription = json['meta_description'],
        price = json['special_price'] != null
            ? StringService.roundString(json['special_price'], 3)
            : StringService.roundString(json['price'], 3),
        beforePrice = json['price'] != null
            ? StringService.roundString(json['price'], 3)
            : null,
        discount = _getDiscount(
            json['special_price'] != null
                ? json['special_price']
                : json['price'],
            json['price']),
        imageUrl = json['image_url'],
        hasOptions = json['has_options'],
        addCartUrl = json['add_cart_url'],
        productId = json['product_id'],
        gallery = json['gallery'],
        reviews = json['reviews'],
        specification = _getSpecifications(json['attributes']),
        brandEntity = json['brand_id'] != null
            ? BrandEntity(
                optionId: json['brand_id'],
                brandLabel: json['brand_label'],
                brandThumbnail: json['brand_thumbnail'],
                brandImage: json['brand_thumbnail'],
              )
            : null,
        stockQty = json['stockQty'],
        configurable = json['configurable'],
        variants = _getVariants(json['child_products']),
        isDeal = json['sale'] == '1',
        categories = json['categories'],
        subCategories = json['subcategories'],
        parentCategories = json['parentcategories'];

  static List<Specification> _getSpecifications(
    Map<String, dynamic>? _specification,
  ) {
    List<Specification> _list = [];
    if (_specification!.length > 0) {
      _specification.forEach((key, element) {
        _list.add(Specification.fromJson(element));
      });
    }
    return _list;
  }

  static List<ProductModel> _getVariants(List<dynamic>? list) {
    List<ProductModel> variants = [];
    if (list != null) {
      for (var item in list) {
        variants.add(ProductModel.fromJson(item));
      }
    }
    return variants;
  }

  ProductEntity.fromProduct(ProductModel product)
      : entityId = product.entityId,
        typeId = product.typeId ?? '',
        sku = product.sku ?? '',
        inStock = (product.stockQty ?? 0) > 0 ? true : false,
        metaKeyword = product.metaKeyword ?? '',
        description = product.description ?? '',
        fullDescription = product.description ?? '',
        shortDescription = product.shortDescription ?? '',
        name = product.name,
        metaDescription = product.metaDescription,
        price = product.price,
        beforePrice = product.beforePrice ?? '',
        discount = product.discount ?? 0,
        imageUrl = product.imageUrl,
        hasOptions = product.hasOptions,
        addCartUrl = product.addCartUrl,
        productId = product.productId,
        gallery = [product.imageUrl],
        stockQty = product.stockQty ?? 0,
        brandEntity = product.brandEntity,
        reviews = null,
        specification = null,
        configurable = null,
        variants = _getVariants(null),
        isDeal = product.isDeal ?? false,
        categories = <String>[],
        subCategories = <String>[],
        parentCategories = <String>[];

  static int _getDiscount(String? afterPriceString, String? beforePriceString) {
    double afterPrice = double.parse(afterPriceString!);
    double beforePrice = double.parse(beforePriceString!);
    if (beforePrice == 0) {
      return 0;
    }
    return (((beforePrice - afterPrice) / beforePrice * 100) + 0.5).floor();
  }

  Future requestPriceAlarm(
    String type,
    String productId, {
    Map<String, dynamic>? data,
  }) async {
    if (data == null) data = {};
    data['type'] = type;
    data['productId'] = productId;
    data['email'] = user!.email;
    await Api.getMethod(
      EndPoints.requestPriceAlarm,
      data: data,
      extra: {"refresh": true},
    );
  }
}
