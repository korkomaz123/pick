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
  final ProductRepository productRepository;
  final LocalStorageRepository localStorageRepository;

  HomeChangeNotifier({
    this.productRepository,
    this.localStorageRepository,
  });

  List<SliderImageEntity> newArrivalsBanners = [];
  List<SliderImageEntity> fragrancesBanners = [];
  List<SliderImageEntity> smartTechBanners = [];
  List<ProductModel> newArrivalsProducts = [];
  List<ProductModel> perfumesProducts = [];
  List<ProductModel> recentlyViewedProducts = [];
  List<ProductModel> orientalProducts = [];
  List<ProductModel> bestDealsItems = [];
  List<ProductModel> newArrivalsItems = [];
  List<ProductModel> perfumesItems = [];
  List<ProductModel> bestWatchesItems = [];
  List<ProductModel> groomingItems = [];
  List<ProductModel> smartTechItems = [];
  List<CategoryEntity> groomingCategories = [];
  SliderImageEntity ads;
  SliderImageEntity megaBanner;
  SliderImageEntity exculisiveBanner;
  SliderImageEntity bestWatchesBanner;
  String message;
  String newArrivalsTitle = '';
  String perfumesTitle = '';
  String bestDealsBannerTitle = '';
  String newArrivalsBannerTitle = '';
  String orientalTitle = '';
  String fragrancesBannersTitle = '';
  String groomingTitle = '';
  String smartTechTitle = '';
  CategoryEntity orientalCategory;
  CategoryEntity groomingCategory;
  CategoryEntity smartTechCategory;

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

  void loadNewArrivals(String lang) async {
    try {
      String key = 'newarrivals-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        newArrivalsTitle = await localStorageRepository.getItem(key + 'title');
        List<dynamic> newArrivalsList = await localStorageRepository.getItem(key);
        newArrivalsProducts = [];
        for (int i = 0; i < newArrivalsList.length; i++) {
          newArrivalsProducts.add(ProductModel.fromJson(newArrivalsList[i]));
        }
        notifyListeners();
      }
      final result = await productRepository.getNewArrivalsProducts(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['products']);
        await localStorageRepository.setItem(key + 'title', result['title']);
        if (!exist) {
          newArrivalsTitle = result['title'];
          List<dynamic> newArrivalsList = result['products'];
          newArrivalsProducts = [];
          for (int i = 0; i < newArrivalsList.length; i++) {
            newArrivalsProducts.add(ProductModel.fromJson(newArrivalsList[i]));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loadPerfumes(String lang) async {
    try {
      String key = 'perfumes-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        perfumesTitle = await localStorageRepository.getItem(key + 'title');
        List<dynamic> perfumesList = await localStorageRepository.getItem(key);
        perfumesProducts = [];
        for (int i = 0; i < perfumesList.length; i++) {
          perfumesProducts.add(ProductModel.fromJson(perfumesList[i]));
        }
      }
      final result = await productRepository.getPerfumesProducts(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['products']);
        await localStorageRepository.setItem(key + 'title', result['title']);
        if (!exist) {
          perfumesTitle = result['title'];
          List<dynamic> perfumesList = result['products'];
          perfumesProducts = [];
          for (int i = 0; i < perfumesList.length; i++) {
            perfumesProducts.add(ProductModel.fromJson(perfumesList[i]));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loadAds(String lang) async {
    try {
      String key = 'homeads-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        final result = await localStorageRepository.getItem(key);
        final adsData = result.containsKey('data') ? result['data'] : null;
        final adsItems = result.containsKey('items') ? result['items'] : [];
        if (adsData != null) {
          ads = SliderImageEntity.fromJson(adsData);
          perfumesItems = [];
          for (var item in adsItems) {
            perfumesItems.add(ProductModel.fromJson(item));
          }
          notifyListeners();
        }
      }
      var result = await homeRepository.getHomeAds(lang);
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
        await localStorageRepository.setItem(
          key,
          {'data': result['data'], 'items': result['items']},
        );
        if (!exist) {
          perfumesItems = [];
          for (var item in result['items']) {
            perfumesItems.add(ProductModel.fromJson(item));
          }
          ads = SliderImageEntity.fromJson(result['data']);
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
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

  void loadExculisiveBanner(String lang) async {
    final result = await homeRepository.getHomeExculisiveBanner(lang);
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

  void loadOrientalProducts(String lang) async {
    try {
      String key = 'oriental-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        orientalTitle = await localStorageRepository.getItem(key + 'title');
        orientalCategory = CategoryEntity.fromJson(await localStorageRepository.getItem(key + 'category'));
        List<dynamic> orientalList = await localStorageRepository.getItem(key);
        orientalProducts = [];
        for (int i = 0; i < orientalList.length; i++) {
          orientalProducts.add(ProductModel.fromJson(orientalList[i]));
        }
      }
      final result = await productRepository.getOrientalProducts(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['products']);
        await localStorageRepository.setItem(key + 'title', result['title']);
        await localStorageRepository.setItem(key + 'category', result['category']);
        if (!exist) {
          orientalTitle = result['title'];
          orientalCategory = CategoryEntity.fromJson(result['category']);
          List<dynamic> orientalList = result['products'];
          orientalProducts = [];
          for (int i = 0; i < orientalList.length; i++) {
            orientalProducts.add(ProductModel.fromJson(orientalList[i]));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
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

  void loadNewArrivalsBanner(String lang) async {
    try {
      String key = 'new-arrivals-banners-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        Map<String, dynamic> data = await localStorageRepository.getItem(key);
        newArrivalsBannerTitle = data['title'];
        List<dynamic> sliderImageList = data['banners'];
        List<dynamic> sliderItems = data.containsKey('items') ? data['items'] : [];
        newArrivalsBanners = [];
        newArrivalsItems = [];
        for (var banner in sliderImageList) {
          newArrivalsBanners.add(SliderImageEntity.fromJson(banner));
        }
        for (var item in sliderItems) {
          newArrivalsItems.add(ProductModel.fromJson(item));
        }
        notifyListeners();
      }
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
        await localStorageRepository.setItem(
          key,
          {'title': result['title'], 'banners': result['data'], 'items': result['items']},
        );
        if (!exist) {
          newArrivalsBannerTitle = result['title'];
          List<dynamic> sliderImageList = result['data'];
          List<dynamic> sliderItems = result['items'];
          newArrivalsBanners = [];
          newArrivalsItems = [];
          for (var banner in sliderImageList) {
            newArrivalsBanners.add(SliderImageEntity.fromJson(banner));
          }
          for (var item in sliderItems) {
            newArrivalsItems.add(ProductModel.fromJson(item));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loadFragrancesBanner(String lang) async {
    try {
      String key = 'fragrances-banners-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        Map<String, dynamic> data = await localStorageRepository.getItem(key);
        fragrancesBannersTitle = data['title'];
        List<dynamic> sliderImageList = data['banners'];
        fragrancesBanners = [];
        for (var banner in sliderImageList) {
          fragrancesBanners.add(SliderImageEntity.fromJson(banner));
        }
        notifyListeners();
      }
      final result = await homeRepository.getHomeFragrancesBanners(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(
          key,
          {'title': result['title'], 'banners': result['data']},
        );
        if (!exist) {
          fragrancesBannersTitle = result['title'];
          List<dynamic> sliderImageList = result['data'];
          fragrancesBanners = [];
          for (var banner in sliderImageList) {
            fragrancesBanners.add(SliderImageEntity.fromJson(banner));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loadBestWatches(String lang) async {
    try {
      String key = 'best-watches-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        Map<String, dynamic> data = await localStorageRepository.getItem(key);
        List<dynamic> sliderImageList = data['banners'];
        List<dynamic> sliderItems = data.containsKey('items') ? data['items'] : [];
        bestWatchesBanner = null;
        bestWatchesItems = [];
        bestWatchesBanner = SliderImageEntity.fromJson(sliderImageList[0]);
        for (var item in sliderItems) {
          bestWatchesItems.add(ProductModel.fromJson(item));
        }
        notifyListeners();
      }
      final result = await homeRepository.getHomeBestWatches(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(
          key,
          {'banners': result['data'], 'items': result['products']},
        );
        if (!exist) {
          List<dynamic> sliderImageList = result['data'];
          List<dynamic> sliderItems = result['products'];
          bestWatchesBanner = null;
          bestWatchesItems = [];
          bestWatchesBanner = SliderImageEntity.fromJson(sliderImageList[0]);
          for (var item in sliderItems) {
            bestWatchesItems.add(ProductModel.fromJson(item));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loadGrooming(String lang) async {
    try {
      String key = 'grooming-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        Map<String, dynamic> data = await localStorageRepository.getItem(key);
        List<dynamic> groomingCategoriesList = data['categories'];
        List<dynamic> groomingItemsList = data.containsKey('items') ? data['items'] : [];
        groomingTitle = data['title'];
        groomingCategory = CategoryEntity.fromJson(data['category']);
        groomingCategories = [];
        groomingItems = [];
        for (var item in groomingCategoriesList) {
          groomingCategories.add(CategoryEntity.fromJson(item));
        }
        for (var item in groomingItemsList) {
          groomingItems.add(ProductModel.fromJson(item));
        }
        notifyListeners();
      }
      final result = await homeRepository.getHomeGrooming(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(
          key,
          {
            'title': result['title'],
            'categories': result['data'],
            'items': result['products'],
            'category': result['category'],
          },
        );
        if (!exist) {
          List<dynamic> groomingCategoriesList = result['data'];
          List<dynamic> groomingItemsList = result['products'];
          groomingTitle = result['title'];
          groomingCategory = CategoryEntity.fromJson(result['category']);
          groomingCategories = [];
          groomingItems = [];
          for (var item in groomingCategoriesList) {
            groomingCategories.add(CategoryEntity.fromJson(item));
          }
          for (var item in groomingItemsList) {
            groomingItems.add(ProductModel.fromJson(item));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loadSmartTech(String lang) async {
    try {
      String key = 'smart-tech-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        Map<String, dynamic> data = await localStorageRepository.getItem(key);
        List<dynamic> sliderImageList = data['banners'];
        List<dynamic> sliderItems = data.containsKey('items') ? data['items'] : [];
        smartTechTitle = data['title'];
        smartTechCategory = CategoryEntity.fromJson(data['category']);
        smartTechBanners = [];
        smartTechItems = [];
        for (var item in sliderImageList) {
          smartTechBanners.add(SliderImageEntity.fromJson(item));
        }
        for (var item in sliderItems) {
          smartTechItems.add(ProductModel.fromJson(item));
        }
        notifyListeners();
      }
      final result = await homeRepository.getHomeSmartTech(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(
          key,
          {
            'title': result['title'],
            'banners': result['data'],
            'items': result['products'],
            'category': result['category'],
          },
        );
        if (!exist) {
          List<dynamic> sliderImageList = result['data'];
          List<dynamic> sliderItems = result['products'];
          smartTechTitle = result['title'];
          smartTechCategory = CategoryEntity.fromJson(result['category']);
          smartTechBanners = [];
          smartTechItems = [];
          for (var item in sliderImageList) {
            smartTechBanners.add(SliderImageEntity.fromJson(item));
          }
          for (var item in sliderItems) {
            smartTechItems.add(ProductModel.fromJson(item));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
