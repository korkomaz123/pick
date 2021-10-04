import 'package:flutter/foundation.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../preload.dart';

class ProductChangeNotifier extends ChangeNotifier {
  final productRepository = ProductRepository();

  bool isLoading = false;
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
    final result =
        await productRepository.getProductInfo(productId, Preload.language);
    List<dynamic> galleryImages = productDetails?.gallery ?? [];
    if (result['code'] == 'SUCCESS') {
      productDetails = null;
      galleryImages.addAll(result['moreAbout']['gallery']);
      if (galleryImages.length != result['moreAbout']['gallery'].length)
        galleryImages.removeAt(0);
      result['moreAbout']['gallery'] = galleryImages;
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
    String key,
    String categoryId,
    String lang,
  ) async {
    isReachedMax = false;
    if (!data.containsKey(key)) {
      pages[key] = 1;
      await loadCategoryProducts(key, 1, categoryId, lang);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadMoreCategoryProducts(
    String key,
    int page,
    String categoryId,
    String lang,
  ) async {
    isLoading = true;
    notifyListeners();
    pages[key] = page;
    await loadCategoryProducts(key, page, categoryId, lang);
  }

  Future<void> refreshCategoryProducts(
    String key,
    String categoryId,
    String lang,
  ) async {
    data[key] = <ProductModel>[];
    pages[key] = 1;
    isReachedMax = false;
    await loadCategoryProducts(key, 1, categoryId, lang);
  }

  Future<void> loadCategoryProducts(
    String key,
    int page,
    String categoryId,
    String lang,
  ) async {
    final result = await productRepository.getProducts(categoryId, lang, page);
    if (result['code'] == 'SUCCESS') {
      if (result['currentpage'] != null) currentpage[key] = page.toString();
      if (result['totalpage'] != null)
        totalPages[key] = result['totalpage'].toString();
      if (result['totalproducts'] != null)
        totalProducts[key] = result['totalproducts'].toString();

      List<dynamic> productList = result['products'];
      if (!data.containsKey(key)) {
        data[key] = [];
      }
      for (int i = 0; i < productList.length; i++) {
        data[key].add(ProductModel.fromJson(productList[i]));
      }
      if (productList.length < 50 && page > 0) {
        isReachedMax = true;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  /// brand products list loading...
  Future<void> initialLoadBrandProducts(
    String key,
    String brandId,
    String categoryId,
    String lang,
  ) async {
    isReachedMax = false;
    if (!data.containsKey(key)) {
      pages[key] = 1;
      await loadBrandProducts(key, 1, brandId, categoryId, lang);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadMoreBrandProducts(
    String key,
    int page,
    String brandId,
    String categoryId,
    String lang,
  ) async {
    isLoading = true;
    notifyListeners();
    pages[key] = page;
    await loadBrandProducts(key, page, brandId, categoryId, lang);
  }

  Future<void> refreshBrandProducts(
    String key,
    String brandId,
    String categoryId,
    String lang,
  ) async {
    data[key] = <ProductModel>[];
    pages[key] = 1;
    isReachedMax = false;
    await loadBrandProducts(key, 1, brandId, categoryId, lang);
  }

  Future<void> loadBrandProducts(
    String key,
    int page,
    String brandId,
    String categoryId,
    String lang,
  ) async {
    final result = await productRepository.getBrandProducts(
        brandId, categoryId, lang, page);
    if (result['code'] == 'SUCCESS') {
      print('key ==== > $key');
      if (result['currentpage'] != null) currentpage[key] = page.toString();
      if (result['totalpage'] != null)
        totalPages[key] = result['totalpage'].toString();
      if (result['totalproducts'] != null)
        totalProducts[key] = result['totalproducts'].toString();

      List<dynamic> productList = result['products'];
      if (!data.containsKey(key)) {
        data[key] = [];
      }
      for (int i = 0; i < productList.length; i++) {
        if (data[key]
                .where((element) => element.sku == productList[i]['sku'])
                .toList()
                .length ==
            0) data[key].add(ProductModel.fromJson(productList[i]));
      }
      if (productList.length < 50 && page > 0) {
        isReachedMax = true;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  /// sorted products list loading...
  Future<void> initialLoadSortedProducts(
    String key,
    String brandId,
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    isReachedMax = false;
    if (!data.containsKey(key)) {
      pages[key] = 1;
      await loadSortedProducts(key, 1, brandId, categoryId, sortItem, lang);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadMoreSortedProducts(
    String key,
    int page,
    String brandId,
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    isLoading = true;
    notifyListeners();
    pages[key] = page;
    await loadSortedProducts(key, page, brandId, categoryId, sortItem, lang);
  }

  Future<void> refreshSortedProducts(
    String key,
    String brandId,
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    data[key] = <ProductModel>[];
    pages[key] = 1;
    isReachedMax = false;
    await loadSortedProducts(key, 1, brandId, categoryId, sortItem, lang);
  }

  Map<String, dynamic> totalPages = {};
  Map<String, dynamic> totalProducts = {};
  Map<String, dynamic> currentpage = {};
  Future<void> loadSortedProducts(
    String key,
    int page,
    String brandId,
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    final result = await productRepository.sortProducts(
        categoryId == 'all' ? null : categoryId, brandId, sortItem, lang, page);
    if (result['code'] == 'SUCCESS') {
      print('key ==== > $key');
      if (result['currentpage'] != null) currentpage[key] = page.toString();
      if (result['totalpage'] != null)
        totalPages[key] = result['totalpage'].toString();
      if (result['totalproducts'] != null)
        totalProducts[key] = result['totalproducts'].toString();
      List<dynamic> productList = result['products'];
      if (!data.containsKey(key)) {
        data[key] = [];
      }
      for (int i = 0; i < productList.length; i++) {
        if (data[key]
                .where((element) => element.sku == productList[i]['sku'])
                .toList()
                .length ==
            0) data[key].add(ProductModel.fromJson(productList[i]));
      }
      if (productList.length < 50 && page > 0) {
        isReachedMax = true;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  /// filter products
  Future<void> initialLoadFilteredProducts(
    String key,
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
    String lang,
  ) async {
    isReachedMax = false;
    data[key] = null;
    pages[key] = 1;
    await loadFilteredProducts(key, 1, brandId, categoryId, filterValues, lang);
  }

  Future<void> loadMoreFilteredProducts(
    String key,
    int page,
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
    String lang,
  ) async {
    isLoading = true;
    notifyListeners();
    pages[key] = page;
    await loadFilteredProducts(
        key, page, brandId, categoryId, filterValues, lang);
  }

  Future<void> refreshFilteredProducts(
    String key,
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
    String lang,
  ) async {
    data[key] = <ProductModel>[];
    pages[key] = 1;
    isReachedMax = false;
    await loadFilteredProducts(key, 1, brandId, categoryId, filterValues, lang);
  }

  Future<void> loadFilteredProducts(
    String key,
    int page,
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
    String lang,
  ) async {
    final result = await productRepository.filterProducts(
      categoryId == 'all' ? null : categoryId,
      brandId,
      filterValues,
      lang,
      page,
    );
    if (result['code'] == 'SUCCESS') {
      List<dynamic> productList = result['products'];
      if (!data.containsKey(key) || data[key] == null) {
        data[key] = [];
      }
      for (int i = 0; i < productList.length; i++) {
        if (data[key]
                .where((element) => element.sku == productList[i]['sku'])
                .toList()
                .length ==
            0) data[key].add(ProductModel.fromJson(productList[i]));
      }
      if (productList.length < 50 && page > 0) {
        isReachedMax = true;
      }
      isLoading = false;
      notifyListeners();
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
