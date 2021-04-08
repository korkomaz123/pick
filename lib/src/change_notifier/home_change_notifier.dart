import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/utils/repositories/home_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

class HomeChangeNotifier extends ChangeNotifier {
  final HomeRepository homeRepository;
  final ProductRepository productRepository;
  final LocalStorageRepository localStorageRepository;

  HomeChangeNotifier({
    this.homeRepository,
    this.productRepository,
    this.localStorageRepository,
  });

  List<SliderImageEntity> sliderImages = [];
  List<SliderImageEntity> newArrivalsBanners = [];
  List<SliderImageEntity> bestDealsBanners = [];
  List<ProductModel> bestDealsProducts = [];
  List<ProductModel> newArrivalsProducts = [];
  List<ProductModel> perfumesProducts = [];
  List<ProductModel> recentlyViewedProducts = [];
  List<ProductModel> orientalProducts = [];
  SliderImageEntity ads;
  SliderImageEntity popupItem;
  SliderImageEntity megaBanner;
  SliderImageEntity exculisiveBanner;
  String message;
  String bestDealsTitle = '';
  String newArrivalsTitle = '';
  String perfumesTitle = '';
  String bestDealsBannerTitle = '';
  String newArrivalsBannerTitle = '';
  String orientalTitle = '';
  List<ProductModel> bestDealsItems = [];
  List<ProductModel> newArrivalsItems = [];
  List<ProductModel> perfumesItems = [];
  CategoryEntity orientalCategory;

  void loadPopup(String lang, Function onSuccess) async {
    try {
      final result = await homeRepository.getPopupItem(lang);
      if (result['code'] == 'SUCCESS') {
        popupItem = SliderImageEntity.fromJson(result['data'][0]);
        onSuccess(popupItem);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loadSliderImages(String lang) async {
    try {
      String key = 'slider-images-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        List<dynamic> sliderImageList =
            await localStorageRepository.getItem(key);
        sliderImages = [];
        for (int i = 0; i < sliderImageList.length; i++) {
          sliderImages.add(SliderImageEntity.fromJson(sliderImageList[i]));
        }
        notifyListeners();
      }
      final result = await homeRepository.getHomeSliderImages(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['data']);
        if (!exist) {
          List<dynamic> sliderImageList = result['data'];
          sliderImages = [];
          for (int i = 0; i < sliderImageList.length; i++) {
            sliderImages.add(SliderImageEntity.fromJson(sliderImageList[i]));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loadBestDeals(String lang) async {
    try {
      String key = 'bestdeals-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        bestDealsTitle = await localStorageRepository.getItem(key + 'title');
        List<dynamic> bestDealsList = await localStorageRepository.getItem(key);
        bestDealsProducts = [];
        for (int i = 0; i < bestDealsList.length; i++) {
          bestDealsProducts.add(ProductModel.fromJson(bestDealsList[i]));
        }
        notifyListeners();
      }
      final result = await productRepository.getBestDealsProducts(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['products']);
        await localStorageRepository.setItem(key + 'title', result['title']);
        if (!exist) {
          bestDealsTitle = result['title'];
          List<dynamic> bestDealsList = result['products'];
          bestDealsProducts = [];
          for (int i = 0; i < bestDealsList.length; i++) {
            bestDealsProducts.add(ProductModel.fromJson(bestDealsList[i]));
          }
          notifyListeners();
        }
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
        List<dynamic> newArrivalsList =
            await localStorageRepository.getItem(key);
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
          response = await productRepository.getProducts(
              adsData['category_id'], lang, 1);
        } else if (adsData['brand_id'] != null) {
          response = await productRepository.getBrandProducts(
              adsData['brand_id'], 'all', lang, 1);
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
      final result =
          await productRepository.getHomeRecentlyViewedGuestProducts(ids, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> recentlyViewedList = result['items'];
        recentlyViewedProducts = [];
        for (int i = 0; i < recentlyViewedList.length; i++) {
          recentlyViewedProducts
              .add(ProductModel.fromJson(recentlyViewedList[i]));
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
      final result = await productRepository
          .getHomeRecentlyViewedCustomerProducts(token, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> recentlyViewedList = result['products'];
        recentlyViewedProducts = [];
        for (int i = 0; i < recentlyViewedList.length; i++) {
          recentlyViewedProducts
              .add(ProductModel.fromJson(recentlyViewedList[i]));
        }
        notifyListeners();
      }
    } catch (e) {
      print('error customer');
      print(e.toString());
    }
  }

  void loadMegaBanner(String lang) async {
    final result = await homeRepository.getHomeMegaBanner(lang);
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
        orientalCategory = CategoryEntity.fromJson(
            await localStorageRepository.getItem(key + 'category'));
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
        await localStorageRepository.setItem(
            key + 'category', result['category']);
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

  void loadBestDealsBanner(String lang) async {
    try {
      String key = 'best-deals-banners-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        Map<String, dynamic> data = await localStorageRepository.getItem(key);
        bestDealsBannerTitle = data['title'];
        List<dynamic> sliderImageList = data['banners'];
        List<dynamic> sliderItems =
            data.containsKey('items') ? data['items'] : [];
        bestDealsBanners = [];
        bestDealsItems = [];
        for (var banner in sliderImageList) {
          bestDealsBanners.add(SliderImageEntity.fromJson(banner));
        }
        for (var item in sliderItems) {
          bestDealsItems.add(ProductModel.fromJson(item));
        }
        notifyListeners();
      }
      final result = await homeRepository.getHomeBestDealsBanners(lang);
      if (result['code'] == 'SUCCESS') {
        dynamic response;
        if (result['data'][0]['category_id'] != null) {
          response = await productRepository.getProducts(
              result['data'][0]['category_id'], lang, 1);
        } else if (result['data'][0]['brand_id'] != null) {
          response = await productRepository.getBrandProducts(
              result['data'][0]['brand_id'], 'all', lang, 1);
        }
        if (response['code'] == 'SUCCESS') {
          result['items'] = response['products'];
        } else {
          result['items'] = [];
        }
        await localStorageRepository.setItem(
          key,
          {
            'title': result['title'],
            'banners': result['data'],
            'items': result['items']
          },
        );
        if (!exist) {
          bestDealsBannerTitle = result['title'];
          List<dynamic> sliderImageList = result['data'];
          List<dynamic> sliderItems = result['items'];
          bestDealsBanners = [];
          bestDealsItems = [];
          for (var banner in sliderImageList) {
            bestDealsBanners.add(SliderImageEntity.fromJson(banner));
          }
          for (var item in sliderItems) {
            bestDealsItems.add(ProductModel.fromJson(item));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print('best deals banner');
      print(e.toString());
    }
  }

  void loadNewArrivalsBanner(String lang) async {
    try {
      String key = 'new-arrivals-banners-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        Map<String, dynamic> data = await localStorageRepository.getItem(key);
        newArrivalsBannerTitle = data['title'];
        List<dynamic> sliderImageList = data['banners'];
        List<dynamic> sliderItems =
            data.containsKey('items') ? data['items'] : [];
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
          response = await productRepository.getProducts(
              result['data'][0]['category_id'], lang, 1);
        } else if (result['data'][0]['brand_id'] != null) {
          response = await productRepository.getBrandProducts(
              result['data'][0]['brand_id'], 'all', lang, 1);
        }
        if (response['code'] == 'SUCCESS') {
          result['items'] = response['products'];
        } else {
          result['items'] = [];
        }
        await localStorageRepository.setItem(
          key,
          {
            'title': result['title'],
            'banners': result['data'],
            'items': result['items']
          },
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
}
