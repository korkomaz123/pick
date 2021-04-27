import 'package:flutter/material.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/home_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../config.dart';

class HomeChangeNotifier extends ChangeNotifier {
  final HomeRepository homeRepository = HomeRepository();
  final CategoryRepository categoryRepository = CategoryRepository();
  final ProductRepository productRepository = ProductRepository();
  final LocalStorageRepository localStorageRepository = LocalStorageRepository();

  List<ProductModel> recentlyViewedProducts = [];
  List<ProductModel> bestDealsItems = [];
  SliderImageEntity megaBanner;
  String message;
  String bestDealsBannerTitle = '';

  changeLanguage() {
    loadSliderImages();
    getFeaturedCategoriesList();
    loadBestDeals();
    getHomeCategories();
  }

  List<SliderImageEntity> sliderImages = [];
  Future loadSliderImages() async {
    try {
      String key = 'slider-images-${Config.language}';
      final result = await homeRepository.getHomeSliderImages(Config.language);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['data']);
        sliderImages.clear();
        for (int i = 0; i < result['data'].length; i++) {
          sliderImages.add(SliderImageEntity.fromJson(result['data'][i]));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  List<CategoryEntity> featuredCategories = [];
  Future getFeaturedCategoriesList() async {
    final result = await categoryRepository.getFeaturedCategories(Config.language);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> categoryList = result['categories'];
      featuredCategories.clear();
      for (int i = 0; i < categoryList.length; i++) {
        featuredCategories.add(CategoryEntity.fromJson(categoryList[i]));
      }
    }
    notifyListeners();
  }

  String bestDealsTitle = '';
  List<ProductModel> bestDealsProducts = [];
  Future loadBestDeals() async {
    try {
      final result = await productRepository.getBestDealsProducts(Config.language);
      if (result['code'] == 'SUCCESS') {
        bestDealsTitle = result['title'];
        bestDealsProducts.clear();
        for (int i = 0; i < result['products'].length; i++) {
          bestDealsProducts.add(ProductModel.fromJson(result['products'][i]));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    await getHomeCategories();
    notifyListeners();
  }

  Future getHomeCategories() async {
    final params = {'lang': Config.language};
    final result = await Api.getMethod(EndPoints.getHomeCategories, data: params);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> categoriesList = result['categories'];
      homeCategories.clear();
      for (int i = 0; i < categoriesList.length; i++) {
        homeCategories.add(CategoryEntity.fromJson(categoriesList[i]));
      }
    }
    notifyListeners();
  }

  SliderImageEntity popupItem;
  Future loadPopup(Function onSuccess) async {
    try {
      final result = await homeRepository.getPopupItem(Config.language);
      if (result['code'] == 'SUCCESS') {
        popupItem = SliderImageEntity.fromJson(result['data'][0]);
        onSuccess(popupItem);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future loadMegaBanner() async {
    final result = await homeRepository.getHomeMegaBanner(Config.language);
    try {
      if (result['code'] == 'SUCCESS') {
        megaBanner = SliderImageEntity.fromJson(result['data'][0]);
      } else {
        megaBanner = null;
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  String newArrivalsBannerTitle = '';
  List<SliderImageEntity> newArrivalsBanners = [];
  List<ProductModel> newArrivalsItems = [];
  Future loadNewArrivalsBanner() async {
    try {
      final result = await homeRepository.getHomeNewArrivalsBanners(lang);
      if (result['code'] == 'SUCCESS') {
        dynamic response;
        if (result['data'][0]['category_id'] != null) {
          response = await productRepository.getProducts(result['data'][0]['category_id'], lang, 1);
        } else if (result['data'][0]['brand_id'] != null) {
          response = await productRepository.getBrandProducts(result['data'][0]['brand_id'], 'all', lang, 1);
        }
        if (response['code'] == 'SUCCESS') {
          result['items'] = response['products'];
        } else {
          result['items'] = [];
        }
        newArrivalsBannerTitle = result['title'];
        newArrivalsBanners.clear();
        newArrivalsItems.clear();
        for (var banner in result['data']) {
          newArrivalsBanners.add(SliderImageEntity.fromJson(banner));
        }
        for (var item in result['items']) {
          newArrivalsItems.add(ProductModel.fromJson(item));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  List<ProductModel> newArrivalsProducts = [];
  String newArrivalsTitle = '';
  Future loadNewArrivals() async {
    try {
      final result = await productRepository.getNewArrivalsProducts(lang);
      if (result['code'] == 'SUCCESS') {
        newArrivalsTitle = result['title'];
        newArrivalsProducts.clear();
        for (int i = 0; i < result['products'].length; i++) {
          newArrivalsProducts.add(ProductModel.fromJson(result['products'][i]));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  SliderImageEntity exculisiveBanner;
  Future loadExculisiveBanner() async {
    final result = await homeRepository.getHomeExculisiveBanner(Config.language);
    try {
      if (result['code'] == 'SUCCESS') {
        exculisiveBanner = SliderImageEntity.fromJson(result['data'][0]);
      } else {
        exculisiveBanner = null;
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  List<ProductModel> orientalProducts = [];
  CategoryEntity orientalCategory;
  String orientalTitle = '';
  Future loadOrientalProducts() async {
    try {
      final result = await productRepository.getOrientalProducts(lang);
      if (result['code'] == 'SUCCESS') {
        orientalTitle = result['title'];
        orientalCategory = CategoryEntity.fromJson(result['category']);
        orientalProducts = [];
        for (int i = 0; i < result['products'].length; i++) {
          orientalProducts.add(ProductModel.fromJson(result['products'][i]));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  List<SliderImageEntity> bestDealsBanners = [];
  Future loadBestDealsBanner() async {
    try {
      final result = await homeRepository.getHomeBestDealsBanners(Config.language);
      if (result['code'] == 'SUCCESS') {
        dynamic response;
        if (result['data'][0]['category_id'] != null) {
          response = await productRepository.getProducts(result['data'][0]['category_id'], Config.language, 1);
        } else if (result['data'][0]['brand_id'] != null) {
          response = await productRepository.getBrandProducts(result['data'][0]['brand_id'], 'all', Config.language, 1);
        }
        if (response['code'] == 'SUCCESS') {
          result['items'] = response['products'];
        } else {
          result['items'] = [];
        }
        bestDealsBannerTitle = result['title'];
        bestDealsBanners.clear();
        bestDealsItems.clear();
        for (var banner in result['data']) {
          bestDealsBanners.add(SliderImageEntity.fromJson(banner));
        }
        for (var item in result['items']) {
          bestDealsItems.add(ProductModel.fromJson(item));
        }
      }
    } catch (e) {
      print('best deals banner');
      print(e.toString());
    }
    notifyListeners();
  }

  String fragrancesBannersTitle = '';
  List<SliderImageEntity> fragrancesBanners = [];
  Future loadFragrancesBanner() async {
    try {
      final result = await homeRepository.getHomeFragrancesBanners(lang);
      if (result['code'] == 'SUCCESS') {
        fragrancesBannersTitle = result['title'];
        fragrancesBanners.clear();
        for (var banner in result['data']) {
          fragrancesBanners.add(SliderImageEntity.fromJson(banner));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  String perfumesTitle = '';
  List<ProductModel> perfumesProducts = [];
  Future loadPerfumes() async {
    try {
      final result = await productRepository.getPerfumesProducts(lang);
      if (result['code'] == 'SUCCESS') {
        perfumesTitle = result['title'];
        perfumesProducts.clear();
        for (int i = 0; i < result['products'].length; i++) {
          perfumesProducts.add(ProductModel.fromJson(result['products'][i]));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  SliderImageEntity bestWatchesBanner;
  List<ProductModel> bestWatchesItems = [];
  Future loadBestWatches() async {
    try {
      final result = await homeRepository.getHomeBestWatches(Config.language);
      if (result['code'] == 'SUCCESS') {
        bestWatchesBanner = null;
        bestWatchesBanner = SliderImageEntity.fromJson(result['data'][0]);
        bestWatchesItems.clear();
        for (var item in result['products']) {
          bestWatchesItems.add(ProductModel.fromJson(item));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  SliderImageEntity ads;
  List<ProductModel> perfumesItems = [];
  Future loadAds() async {
    try {
      var result = await homeRepository.getHomeAds(Config.language);
      if (result['code'] == 'SUCCESS') {
        final adsData = result['data'];
        var response;
        if (adsData['category_id'] != null) {
          response = await productRepository.getProducts(adsData['category_id'], lang, 1);
        } else if (adsData['brand_id'] != null) {
          response = await productRepository.getBrandProducts(adsData['brand_id'], 'all', lang, 1);
        }
        if (response['code'] == 'SUCCESS') {
          result['items'] = response['products'];
        } else {
          result['items'] = [];
        }
        perfumesItems.clear();
        for (var item in result['items']) {
          perfumesItems.add(ProductModel.fromJson(item));
        }
        ads = SliderImageEntity.fromJson(result['data']);
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  void loadRecentlyViewedGuest(List<String> ids, String lang) async {
    try {
      final result = await productRepository.getHomeRecentlyViewedGuestProducts(ids, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> recentlyViewedList = result['items'];
        recentlyViewedProducts = [];
        for (int i = 0; i < recentlyViewedList.length; i++) {
          recentlyViewedProducts.add(ProductModel.fromJson(recentlyViewedList[i]));
        }
        notifyListeners();
      }
    } catch (e) {
      print('error guest');
      print(e.toString());
    }
  }

  void loadRecentlyViewedCustomer(String token, String lang) async {
    try {
      final result = await productRepository.getHomeRecentlyViewedCustomerProducts(token, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> recentlyViewedList = result['products'];
        recentlyViewedProducts = [];
        for (int i = 0; i < recentlyViewedList.length; i++) {
          recentlyViewedProducts.add(ProductModel.fromJson(recentlyViewedList[i]));
        }
        notifyListeners();
      }
    } catch (e) {
      print('error customer');
      print(e.toString());
    }
  }

  List<ProductModel> groomingItems = [];
  List<CategoryEntity> groomingCategories = [];
  String groomingTitle = '';
  CategoryEntity groomingCategory;
  Future loadGrooming() async {
    try {
      final result = await homeRepository.getHomeGrooming(lang);
      if (result['code'] == 'SUCCESS') {
        groomingTitle = result['title'];
        groomingCategory = CategoryEntity.fromJson(result['category']);
        groomingCategories.clear();
        groomingItems.clear();
        for (var item in result['data']) {
          groomingCategories.add(CategoryEntity.fromJson(item));
        }
        for (var item in result['products']) {
          groomingItems.add(ProductModel.fromJson(item));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  String smartTechTitle = '';
  List<SliderImageEntity> smartTechBanners = [];
  List<ProductModel> smartTechItems = [];

  CategoryEntity smartTechCategory;
  Future loadSmartTech() async {
    try {
      final result = await homeRepository.getHomeSmartTech(Config.language);
      if (result['code'] == 'SUCCESS') {
        smartTechTitle = result['title'];
        smartTechCategory = CategoryEntity.fromJson(result['category']);
        smartTechBanners.clear();
        smartTechItems.clear();
        for (var item in result['data']) {
          smartTechBanners.add(SliderImageEntity.fromJson(item));
        }
        for (var item in result['products']) {
          smartTechItems.add(ProductModel.fromJson(item));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  List<CategoryEntity> categories = [];
  Future getCategoriesList() async {
    final result = await categoryRepository.getAllCategories(Config.language);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> categoryList = result['categories'];
      categories = [];
      for (int i = 0; i < categoryList.length; i++) {
        categories.add(CategoryEntity.fromJson(categoryList[i]));
      }
    }
    notifyListeners();
  }
}
