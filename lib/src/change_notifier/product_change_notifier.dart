import 'package:flutter/foundation.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../preload.dart';

class ProductChangeNotifier extends ChangeNotifier {
  final productRepository = ProductRepository();

  bool isReachedMax = false;
  String brandId;
  Map<String, List<ProductModel>> data = {};
  Map<String, int> pages = {};
  ProductEntity productDetails;
  Map<String, ProductEntity> productDetailsMap = {};
  Map<String, List<ProductModel>> sameBrandProductsMap = {};
  Map<String, List<BrandEntity>> brandsMap = {};
  Map<String, List<ProductModel>> relatedItemsMap = {};
  Map<String, dynamic> categoryMap = {};
  Map<String, dynamic> selectedOptions = {};
  ProductModel selectedVariant;
  List<String> productIds = [];

  close() {
    String id = productIds[productIds.length - 1];
    productDetailsMap.remove(id);
    sameBrandProductsMap.remove(id);
    brandsMap.remove(id);
    relatedItemsMap.remove(id);
    categoryMap.remove(id);
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

  Future<void> getProductInfoBrand(String productId) async {
    final _items = await productRepository.getProductInfoBrand(productId);
    sameBrandProductsMap[productId] = _items['sameBrandProducts'];
    brandsMap[productId] = _items['brands'];
    categoryMap[productId] = _items['category'];
    notifyListeners();
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
    List<ProductModel> relatedItems = [];
    selectedOptions = {};
    selectedVariant = null;
    final result = await productRepository.getProductInfo(productId, Preload.language);
    List<dynamic> _gallery = productDetails?.gallery ?? [];
    if (result['code'] == 'SUCCESS') {
      productDetails = null;
      _gallery.addAll(result['moreAbout']['gallery']);
      if (_gallery.length != result['moreAbout']['gallery'].length)
        _gallery.removeAt(0);
      result['moreAbout']['gallery'] = _gallery;
      productDetails = ProductEntity.fromJson(result['moreAbout']);
      //Releated products
      for (int i = 0; i < result['relateditems'].length; i++) {
        relatedItems.add(ProductModel.fromJson(result['relateditems'][i]));
      }
    }
    productDetailsMap[productId] = productDetails;
    relatedItemsMap[productId] = relatedItems;

    notifyListeners();
  }

  /// category products list loading...
  Future<void> initialLoadCategoryProducts(
    String categoryId,
    String lang,
  ) async {
    isReachedMax = false;
    if (!data.containsKey(categoryId)) {
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
    final result = await productRepository.getProducts(categoryId, lang, page);
    if (result['code'] == 'SUCCESS') {
      if (result['currentpage'] != null)
        currentpage['-$categoryId'] = page.toString();
      if (result['totalpage'] != null)
        totalPages['-$categoryId'] = result['totalpage'].toString();
      if (result['totalproducts'] != null)
        totalProducts['-$categoryId'] = result['totalproducts'].toString();

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
    final result = await productRepository.getBrandProducts(
        brandId, categoryId, lang, page);
    if (result['code'] == 'SUCCESS') {
      print('key ==== >' + '${brandId != null ? brandId : ''}-$categoryId');
      if (result['currentpage'] != null)
        currentpage['$brandId-$categoryId'] = page.toString();
      if (result['totalpage'] != null)
        totalPages['${brandId != null ? brandId : ''}-$categoryId'] = result['totalpage'].toString();
      if (result['totalproducts'] != null)
        totalProducts['${brandId != null ? brandId : ''}-$categoryId'] = result['totalproducts'].toString();

      List<dynamic> productList = result['products'];
      if (!data.containsKey(index)) {
        data[index] = [];
      }
      for (int i = 0; i < productList.length; i++) {
        if (data[index]
                .where((element) => element.sku == productList[i]['sku'])
                .toList()
                .length ==
            0) data[index].add(ProductModel.fromJson(productList[i]));
      }
      if (productList.length < 50 && page > 0) {
        isReachedMax = true;
      }
      notifyListeners();
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

  Map<String, dynamic> totalPages = {};
  Map<String, dynamic> totalProducts = {};
  Map<String, dynamic> currentpage = {};
  Future<void> loadSortedProducts(
    int page,
    String brandId,
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    final index = sortItem + '_' + (brandId ?? '') + '_' + (categoryId ?? '');
    final result = await productRepository.sortProducts(
        categoryId == 'all' ? null : categoryId, brandId, sortItem, lang, page);
    if (result['code'] == 'SUCCESS') {
      print('key ==== >' + '${brandId != null ? brandId : ''}-$categoryId');
      if (result['currentpage'] != null)
        currentpage['${brandId ?? ''}-$categoryId'] = page.toString();
      if (result['totalpage'] != null)
        totalPages['${brandId != null ? brandId : ''}-$categoryId'] =
            result['totalpage'].toString();
      if (result['totalproducts'] != null)
        totalProducts['${brandId != null ? brandId : ''}-$categoryId'] =
            result['totalproducts'].toString();
      List<dynamic> productList = result['products'];
      if (!data.containsKey(index)) {
        data[index] = [];
      }
      for (int i = 0; i < productList.length; i++) {
        if (data[index]
                .where((element) => element.sku == productList[i]['sku'])
                .toList()
                .length ==
            0) data[index].add(ProductModel.fromJson(productList[i]));
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
          if (data[index]
                  .where((element) => element.sku == productList[i]['sku'])
                  .toList()
                  .length ==
              0) data[index].add(ProductModel.fromJson(productList[i]));
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
        if (!variant.options.containsKey(attributeId) ||
            variant.options[attributeId] != options[attributeId]) {
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
