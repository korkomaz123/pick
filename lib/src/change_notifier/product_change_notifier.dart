import 'package:flutter/foundation.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../preload.dart';

class ProductChangeNotifier extends ChangeNotifier {
  final productRepository = ProductRepository();
  final localStorageRepository = LocalStorageRepository();

  bool isReachedMax = false;
  String brandId;
  Map<String, List<ProductModel>> data = {};
  Map<String, int> pages = {};
  ProductEntity productDetails;
  Map<String, ProductEntity> productDetailsMap = {};
  Map<String, dynamic> selectedOptions = {};
  ProductModel selectedVariant;
  List<String> productIds = [];

  close() {
    String id = productIds[productIds.length - 1];
    productDetailsMap.remove(id);
    productDetails = null;
    selectedOptions = {};
    selectedVariant = null;
    //notifyListeners();
  }

  void initialize() {
    data = {};
    pages = {};
    isReachedMax = false;
  }

  List<ProductModel> sameBrandProducts = [];
  List<BrandEntity> brands = [];
  dynamic category = {};
  Future<void> getProductInfoBrand(String productId) async {
    productRepository.getProductInfoBrand(productId).then((_items) {
      sameBrandProducts = _items['sameBrandProducts'];
      brands = _items['brands'];
      category = _items['category'];
      notifyListeners();
    });
  }

  setInitalInfo(ProductModel product) {
    productIds.add(product.productId);
    if (productDetailsMap.containsKey(product.productId)) {
      productDetails = productDetailsMap[product.productId];
    } else {
      productDetails = ProductEntity.fromProduct(product);
      productDetailsMap[product.productId] = productDetails;
    }
  }

  Future<void> getProductDetails(String productId) async {
    selectedOptions = {};
    selectedVariant = null;
    relatedItems.clear();
    final result = await productRepository.getProductInfo(productId, Preload.language);
    List<dynamic> _gallery = productDetails?.gallery ?? [];
    if (result['code'] == 'SUCCESS') {
      productDetails = null;
      _gallery.addAll(result['moreAbout']['gallery']);
      if (_gallery.length != result['moreAbout']['gallery'].length) _gallery.removeAt(0);
      result['moreAbout']['gallery'] = _gallery;
      productDetails = ProductEntity.fromJson(result['moreAbout']);
      //Releated products
      for (int i = 0; i < result['relateditems'].length; i++) {
        relatedItems.add(ProductModel.fromJson(result['relateditems'][i]));
      }
    }
    productDetailsMap[productId] = productDetails;

    notifyListeners();
  }
  // Future<void> getProductDetails(String productId) async {
  //   selectedOptions = {};
  //   selectedVariant = null;

  //   final result = await productRepository.getProductDetails(productId, Preload.language);

  //   List<dynamic> _gallery = productDetails?.gallery ?? [];
  //   if (result['code'] == 'SUCCESS') {
  //     productDetails = null;
  //     _gallery.addAll(result['moreAbout']['gallery']);
  //     if (_gallery.length != result['moreAbout']['gallery'].length) _gallery.removeAt(0);
  //     result['moreAbout']['gallery'] = _gallery;
  //     productDetails = ProductEntity.fromJson(result['moreAbout']);
  //   }
  //   productDetailsMap[productId] = productDetails;
  //   notifyListeners();
  // }

  List<ProductModel> relatedItems = [];
  // Future<void> getRelatedProducts(String productId) async {
  //   productRepository.getRelatedProducts(productId).then((_items) {
  //     relatedItems = _items;
  //     notifyListeners();
  //   });
  // }

  /// category products list loading...
  Future<void> initialLoadCategoryProducts(
    String categoryId,
    String lang,
  ) async {
    isReachedMax = false;
    if (!data.containsKey(categoryId)) {
      // data[categoryId] = <ProductModel>[];
      pages[categoryId] = 1;
      await loadCategoryProducts(1, categoryId, lang);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadMoreCategoryProducts(
    int page,
    String categoryId,
    String lang,
  ) async {
    pages[categoryId] = page;
    await loadCategoryProducts(page, categoryId, lang);
  }

  Future<void> refreshCategoryProducts(
    String categoryId,
    String lang,
  ) async {
    data[categoryId] = <ProductModel>[];
    pages[categoryId] = 1;
    isReachedMax = false;
    await loadCategoryProducts(1, categoryId, lang);
  }

  Future<void> loadCategoryProducts(
    int page,
    String categoryId,
    String lang,
  ) async {
    String key = 'cat-products-$categoryId-$lang-$page';
    final exist = await localStorageRepository.existItem(key);
    if (exist) {
      List<dynamic> productList = await localStorageRepository.getItem(key);
      if (!data.containsKey(categoryId)) {
        data[categoryId] = [];
      }
      for (int i = 0; i < productList.length; i++) {
        data[categoryId].add(ProductModel.fromJson(productList[i]));
      }
      if (productList.length < 50 && page > 0) {
        isReachedMax = true;
      }
      notifyListeners();
    }
    final result = await productRepository.getProducts(categoryId, lang, page);
    if (result['code'] == 'SUCCESS') {
      await localStorageRepository.setItem(key, result['products']);
      if (!exist) {
        List<dynamic> productList = result['products'];
        if (!data.containsKey(categoryId)) {
          data[categoryId] = [];
        }
        for (int i = 0; i < productList.length; i++) {
          data[categoryId].add(ProductModel.fromJson(productList[i]));
        }
        if (productList.length < 50 && page > 0) {
          isReachedMax = true;
        }
        notifyListeners();
      }
    }
  }

  /// brand products list loading...
  Future<void> initialLoadBrandProducts(
    String brandId,
    String categoryId,
    String lang,
  ) async {
    isReachedMax = false;
    final index = brandId + '_' + categoryId ?? '';
    if (!data.containsKey(index)) {
      pages[index] = 1;
      await loadBrandProducts(1, brandId, categoryId, lang);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadMoreBrandProducts(
    int page,
    String brandId,
    String categoryId,
    String lang,
  ) async {
    final index = brandId + '_' + categoryId ?? '';
    pages[index] = page;
    print(page);
    await loadBrandProducts(page, brandId, categoryId, lang);
  }

  Future<void> refreshBrandProducts(
    String brandId,
    String categoryId,
    String lang,
  ) async {
    final index = brandId + '_' + categoryId ?? '';
    data[index] = <ProductModel>[];
    pages[index] = 1;
    isReachedMax = false;
    await loadBrandProducts(1, brandId, categoryId, lang);
  }

  Future<void> loadBrandProducts(
    int page,
    String brandId,
    String categoryId,
    String lang,
  ) async {
    final index = brandId + '_' + categoryId ?? '';
    String key = 'cat-products-$brandId-$categoryId-$lang-$page';
    final exist = await localStorageRepository.existItem(key);
    if (exist) {
      List<dynamic> productList = await localStorageRepository.getItem(key);
      if (!data.containsKey(index)) {
        data[index] = [];
      }
      for (int i = 0; i < productList.length; i++) {
        data[index].add(ProductModel.fromJson(productList[i]));
      }
      if (productList.length < 50 && page > 0) {
        isReachedMax = true;
      }
      notifyListeners();
    }
    final result = await productRepository.getBrandProducts(brandId, categoryId, lang, page);
    if (result['code'] == 'SUCCESS') {
      await localStorageRepository.setItem(key, result['products']);
      if (!exist) {
        List<dynamic> productList = result['products'];
        if (!data.containsKey(index)) {
          data[index] = [];
        }
        for (int i = 0; i < productList.length; i++) {
          data[index].add(ProductModel.fromJson(productList[i]));
        }
        if (productList.length < 50 && page > 0) {
          isReachedMax = true;
        }
        notifyListeners();
      }
    }
  }

  /// sorted products list loading...
  Future<void> initialLoadSortedProducts(
    String brandId,
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    isReachedMax = false;
    final index = sortItem + '_' + (brandId ?? '') + '_' + (categoryId ?? '');
    if (!data.containsKey(index)) {
      pages[index] = 1;
      await loadSortedProducts(1, brandId, categoryId, sortItem, lang);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadMoreSortedProducts(
    int page,
    String brandId,
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    final index = sortItem + '_' + (brandId ?? '') + '_' + (categoryId ?? '');
    pages[index] = page;
    print(page);
    await loadSortedProducts(page, brandId, categoryId, sortItem, lang);
  }

  Future<void> refreshSortedProducts(
    String brandId,
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    final index = sortItem + '_' + (brandId ?? '') + '_' + (categoryId ?? '');
    data[index] = <ProductModel>[];
    pages[index] = 1;
    isReachedMax = false;
    await loadSortedProducts(1, brandId, categoryId, sortItem, lang);
  }

  Future<void> loadSortedProducts(
    int page,
    String brandId,
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    final index = sortItem + '_' + (brandId ?? '') + '_' + (categoryId ?? '');
    final result = await productRepository.sortProducts(categoryId == 'all' ? null : categoryId, brandId, sortItem, lang, page);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> productList = result['products'];
      if (!data.containsKey(index)) {
        data[index] = [];
      }
      for (int i = 0; i < productList.length; i++) {
        data[index].add(ProductModel.fromJson(productList[i]));
      }
      if (productList.length < 50 && page > 0) {
        isReachedMax = true;
      }
      notifyListeners();
    }
  }

  /// filter products
  Future<void> initialLoadFilteredProducts(
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
    String lang,
  ) async {
    isReachedMax = false;
    final index = 'filter_' + (brandId ?? '') + '_' + (categoryId ?? 'all');
    print(index);
    data[index] = null;
    pages[index] = 1;
    await loadFilteredProducts(1, brandId, categoryId, filterValues, lang);
  }

  Future<void> loadMoreFilteredProducts(
    int page,
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
    String lang,
  ) async {
    final index = 'filter_' + (brandId ?? '') + '_' + (categoryId ?? 'all');
    pages[index] = page;
    await loadFilteredProducts(page, brandId, categoryId, filterValues, lang);
  }

  Future<void> refreshFilteredProducts(
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
    String lang,
  ) async {
    final index = 'filter_' + (brandId ?? '') + '_' + (categoryId ?? 'all');
    data[index] = <ProductModel>[];
    pages[index] = 1;
    isReachedMax = false;
    await loadFilteredProducts(1, brandId, categoryId, filterValues, lang);
  }

  Future<void> loadFilteredProducts(
    int page,
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
    String lang,
  ) async {
    try {
      final index = 'filter_' + (brandId ?? '') + '_' + (categoryId ?? 'all');
      final result = await productRepository.filterProducts(
        categoryId == 'all' ? null : categoryId,
        brandId,
        filterValues,
        lang,
        page,
      );
      if (result['code'] == 'SUCCESS') {
        List<dynamic> productList = result['products'];
        if (!data.containsKey(index) || data[index] == null) {
          data[index] = [];
        }
        for (int i = 0; i < productList.length; i++) {
          data[index].add(ProductModel.fromJson(productList[i]));
        }
        if (productList.length < 50 && page > 0) {
          isReachedMax = true;
        }
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // _updateDetails() {
  //   if (currentColor.isNotEmpty && currentSize.isNotEmpty) {
  //     List<ProductModel> _selectedItem = productDetails.variants
  //         .where((element) =>
  //             element.sku == "${productDetails.sku}-$currentColor-$currentSize")
  //         .toList();
  //     if (_selectedItem.length > 0) {
  //       productDetails = productDetails.copyWith(
  //           imageUrl: _selectedItem.first.imageUrl,
  //           gallery: [_selectedItem.first.imageUrl]);
  //       productDetailsMap[productDetails.productId] = productDetails;
  //     }
  //   }
  // }

  // String currentColor = "";
  // void changeCurrentColor(_color) {
  //   currentColor = _color;
  //   _updateDetails();
  //   notifyListeners();
  // }

  // String currentSize = "";
  // void changeCurrentSize(_size) {
  //   currentSize = _size;
  //   _updateDetails();
  //   notifyListeners();
  // }

  /// select option in configurable product
  void selectOption(
    String productId,
    String attributeId,
    String optionValue,
    bool selected,
  ) {
    if (selected) {
      selectedOptions[attributeId] = optionValue;
    } else {
      selectedOptions.remove(attributeId);
    }
    selectedVariant = null;

    for (var variant in productDetailsMap[productId].variants) {
      if (mapEquals(selectedOptions, variant.options)) {
        selectedVariant = variant;
        break;
      }
    }
    notifyListeners();
  }

  bool checkAttributeOptionAvailability(
    String productId,
    String attrId,
    String optVal,
  ) {
    Map<String, dynamic> options = {};
    for (var key in selectedOptions.keys.toList()) {
      options[key] = selectedOptions[key];
    }
    options[attrId] = optVal;

    bool isAvailable = false;

    for (var variant in productDetailsMap[productId].variants) {
      bool selectable = true;
      for (var attributeId in options.keys.toList()) {
        if (!variant.options.containsKey(attributeId) || variant.options[attributeId] != options[attributeId]) {
          selectable = false;
          break;
        }
      }
      if (selectable) {
        isAvailable = true;
        break;
      }
    }

    return isAvailable;
  }
}
