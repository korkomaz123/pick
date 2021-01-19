import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/product/bloc/product_repository.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:flutter/material.dart';

class ProductChangeNotifier extends ChangeNotifier {
  ProductChangeNotifier({
    @required this.productRepository,
    @required this.localStorageRepository,
  });

  final ProductRepository productRepository;
  final LocalStorageRepository localStorageRepository;

  String brandId;
  Map<String, List<ProductModel>> data = {};
  Map<String, int> pages = {};

  /// category products list loading...
  Future<void> initialLoadCategoryProducts(String categoryId) async {
    if (!data.containsKey(categoryId)) {
      // data[categoryId] = <ProductModel>[];
      pages[categoryId] = 1;
      await loadCategoryProducts(1, categoryId);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadMoreCategoryProducts(int page, String categoryId) async {
    pages[categoryId] = page;
    await loadCategoryProducts(page, categoryId);
  }

  Future<void> refreshCategoryProducts(String categoryId) async {
    data[categoryId] = <ProductModel>[];
    pages[categoryId] = 1;
    await loadCategoryProducts(1, categoryId);
  }

  Future<void> loadCategoryProducts(int page, String categoryId) async {
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
        notifyListeners();
      }
    }
  }

  /// brand products list loading...
  Future<void> initialLoadBrandProducts(
    String brandId,
    String categoryId,
  ) async {
    final index = brandId + '_' + categoryId ?? '';
    if (!data.containsKey(index)) {
      pages[index] = 1;
      await loadBrandProducts(1, brandId, categoryId);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadMoreBrandProducts(
    int page,
    String brandId,
    String categoryId,
  ) async {
    final index = brandId + '_' + categoryId ?? '';
    pages[index] = page;
    print(page);
    await loadBrandProducts(page, brandId, categoryId);
  }

  Future<void> refreshBrandProducts(String brandId, String categoryId) async {
    final index = brandId + '_' + categoryId ?? '';
    data[index] = <ProductModel>[];
    pages[index] = 1;
    await loadBrandProducts(1, brandId, categoryId);
  }

  Future<void> loadBrandProducts(
    int page,
    String brandId,
    String categoryId,
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
        notifyListeners();
      }
    }
  }

  /// sorted products list loading...
  Future<void> initialLoadSortedProducts(
    String brandId,
    String categoryId,
    String sortItem,
  ) async {
    final index = sortItem + '_' + (brandId ?? '') + '_' + (categoryId ?? '');
    if (!data.containsKey(index)) {
      pages[index] = 1;
      await loadSortedProducts(1, brandId, categoryId, sortItem);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadMoreSortedProducts(
    int page,
    String brandId,
    String categoryId,
    String sortItem,
  ) async {
    final index = sortItem + '_' + (brandId ?? '') + '_' + (categoryId ?? '');
    pages[index] = page;
    print(page);
    await loadSortedProducts(page, brandId, categoryId, sortItem);
  }

  Future<void> refreshSortedProducts(
    String brandId,
    String categoryId,
    String sortItem,
  ) async {
    final index = sortItem + '_' + (brandId ?? '') + '_' + (categoryId ?? '');
    data[index] = <ProductModel>[];
    pages[index] = 1;
    await loadSortedProducts(1, brandId, categoryId, sortItem);
  }

  Future<void> loadSortedProducts(
    int page,
    String brandId,
    String categoryId,
    String sortItem,
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
      notifyListeners();
    }
  }

  /// filter products
  Future<void> initialLoadFilteredProducts(
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
  ) async {
    final index = 'filter_' + (brandId ?? '') + '_' + (categoryId ?? 'all');
    print(index);
    data[index] = null;
    pages[index] = 1;
    await loadFilteredProducts(1, brandId, categoryId, filterValues);
  }

  Future<void> loadMoreFilteredProducts(
    int page,
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
  ) async {
    final index = 'filter_' + (brandId ?? '') + '_' + (categoryId ?? 'all');
    pages[index] = page;
    await loadFilteredProducts(page, brandId, categoryId, filterValues);
  }

  Future<void> refreshFilteredProducts(
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
  ) async {
    final index = 'filter_' + (brandId ?? '') + '_' + (categoryId ?? 'all');
    data[index] = <ProductModel>[];
    pages[index] = 1;
    await loadFilteredProducts(1, brandId, categoryId, filterValues);
  }

  Future<void> loadFilteredProducts(
    int page,
    String brandId,
    String categoryId,
    Map<String, dynamic> filterValues,
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
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
