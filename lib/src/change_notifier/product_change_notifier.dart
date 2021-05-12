import 'package:flutter/foundation.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../config.dart';

class ProductChangeNotifier extends ChangeNotifier {
  final ProductRepository productRepository = ProductRepository();
  final LocalStorageRepository localStorageRepository = LocalStorageRepository();

  bool isReachedMax = false;
  String brandId;
  Map<String, List<ProductModel>> data = {};
  Map<String, int> pages = {};
  ProductEntity productDetails;
  Map<String, dynamic> selectedOptions = {};
  ProductModel selectedVariant;

  close() {
    productDetails = null;
  }

  void initialize() {
    data = {};
    pages = {};
    isReachedMax = false;
  }

  setInitalInfo(ProductModel product) {
    productDetails = ProductEntity.fromProduct(product);
  }

  Future<void> getProductDetails(String productId) async {
    selectedOptions = {};
    selectedVariant = null;
    final result = await productRepository.getProductDetails(productId, Config.language);
    List<dynamic> _gallery = productDetails?.gallery ?? [];
    if (result['code'] == 'SUCCESS') {
      productDetails = null;
      _gallery.addAll(result['moreAbout']['gallery']);
      if (_gallery.length != result['moreAbout']['gallery'].length) _gallery.removeAt(1);
      result['moreAbout']['gallery'] = _gallery;
      productDetails = ProductEntity.fromJson(result['moreAbout']);
    }
    notifyListeners();
  }

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

  /// select option in configurable product
  void selectOption(String attributeId, String optionValue) {
    selectedOptions[attributeId] = optionValue;
    selectedVariant = null;
    for (var variant in productDetails.variants) {
      if (mapEquals(selectedOptions, variant.options)) {
        selectedVariant = variant;
        break;
      }
    }
    notifyListeners();
  }
}
