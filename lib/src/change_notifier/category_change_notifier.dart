import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/pages/brand_list/bloc/brand_repository.dart';
import 'package:markaa/src/pages/category_list/bloc/category_repository.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';

class CategoryChangeNotifier extends ChangeNotifier {
  CategoryChangeNotifier({
    this.localStorageRepository,
    this.categoryRepository,
    this.brandRepository,
  });

  final LocalStorageRepository localStorageRepository;
  final CategoryRepository categoryRepository;
  final BrandRepository brandRepository;

  List<CategoryEntity> subCategories;
  bool isLoading = false;
  List<CategoryEntity> categories = [];

  void initialSubCategories() {
    subCategories = null;
    isLoading = false;
    // notifyListeners();
  }

  void getCategoriesList(String lang) async {
    String key = 'categories-$lang';
    final exist = await localStorageRepository.existItem(key);
    if (exist) {
      List<dynamic> categoryList = await localStorageRepository.getItem(key);
      categories = [];
      for (int i = 0; i < categoryList.length; i++) {
        categories.add(CategoryEntity.fromJson(categoryList[i]));
      }
      notifyListeners();
    }
    final result = await categoryRepository.getAllCategories(lang);
    if (result['code'] == 'SUCCESS') {
      await localStorageRepository.setItem(key, result['categories']);
      if (!exist) {
        List<dynamic> categoryList = result['categories'];
        categories = [];
        for (int i = 0; i < categoryList.length; i++) {
          categories.add(CategoryEntity.fromJson(categoryList[i]));
        }
        notifyListeners();
      }
    }
  }

  void getSubCategories(String categoryId, String lang) async {
    subCategories = [];
    isLoading = true;
    notifyListeners();
    try {
      String key = 'cat-subCat-$categoryId-$lang';
      final isCached = await localStorageRepository.existItem(key);
      if (isCached) {
        List<dynamic> categoryList = await localStorageRepository.getItem(key);
        List<CategoryEntity> categories = [];
        for (int i = 0; i < categoryList.length; i++) {
          categories.add(CategoryEntity.fromJson(categoryList[i]));
        }
        subCategories = categories;
        isLoading = false;
        notifyListeners();
      }
      final result =
          await categoryRepository.getSubCategories(categoryId, lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['categories']);
        if (!isCached) {
          List<dynamic> categoryList = result['categories'];
          List<CategoryEntity> categories = [];
          for (int i = 0; i < categoryList.length; i++) {
            categories.add(CategoryEntity.fromJson(categoryList[i]));
          }
          subCategories = categories;
          isLoading = false;
          notifyListeners();
        }
      } else {
        if (!isCached) {
          subCategories = [];
          notifyListeners();
        }
      }
    } catch (e) {
      subCategories = [];
      isLoading = false;
      notifyListeners();
    }
  }

  void getBrandSubCategories(String brandId, String lang) async {
    subCategories = [];
    isLoading = true;
    notifyListeners();
    try {
      String key = 'brand-subCat-$brandId-$lang';
      final isCached = await localStorageRepository.existItem(key);
      if (isCached) {
        List<dynamic> categoryList = await localStorageRepository.getItem(key);
        List<CategoryEntity> categories = [];
        for (int i = 0; i < categoryList.length; i++) {
          categories.add(CategoryEntity.fromJson(categoryList[i]));
        }
        subCategories = categories;
        isLoading = false;
        notifyListeners();
      }
      final result = await brandRepository.getBrandCategories(brandId, lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['categories']);
        if (!isCached) {
          List<dynamic> categoryList = result['categories'];
          List<CategoryEntity> categories = [];
          for (int i = 0; i < categoryList.length; i++) {
            categories.add(CategoryEntity.fromJson(categoryList[i]));
          }
          subCategories = categories;
          isLoading = false;
          notifyListeners();
        }
      } else {
        if (!isCached) {
          subCategories = [];
          isLoading = false;
          notifyListeners();
        }
      }
    } catch (e) {
      subCategories = [];
      isLoading = false;
      notifyListeners();
    }
  }
}
