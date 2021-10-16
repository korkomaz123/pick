import 'package:flutter/material.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';

class CategoryChangeNotifier extends ChangeNotifier {
  final LocalStorageRepository localStorageRepository =
      LocalStorageRepository();
  final CategoryRepository categoryRepository = CategoryRepository();
  final BrandRepository brandRepository = BrandRepository();

  List<CategoryEntity>? subCategories;
  bool isLoading = false;

  void initialSubCategories() {
    subCategories = null;
    isLoading = false;
    // notifyListeners();
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

  List<dynamic> allCelebritiesList = [];
  void getAllCelebrities(String lang) async {
    allCelebritiesList = [];
    isLoading = true;
    notifyListeners();
    try {
      // String key = 'brand-subCat-celebrites-$lang';
      final result = await Api.getMethod(EndPoints.getAllCelebrities,
          data: {'lang': lang});
      if (result['code'] == 'SUCCESS') {
        allCelebritiesList = result['celebrities'];
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      subCategories = [];
      isLoading = false;
      notifyListeners();
    }
  }
}
