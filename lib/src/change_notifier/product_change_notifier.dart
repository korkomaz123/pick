import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/product/bloc/product_repository.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:flutter/material.dart';

class ProductChangeNotifier extends ChangeNotifier {
  ProductChangeNotifier({
    @required this.productRepository,
    @required this.localStorageRepository,
  });

  final ProductRepository productRepository;
  final LocalStorageRepository localStorageRepository;

  String brandId;
  ProductViewEnum viewMode;
  Map<String, List<ProductModel>> data = {};
  Map<String, int> pages = {};

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
}
