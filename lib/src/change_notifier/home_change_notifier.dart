import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/home_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../preload.dart';
import '../apis/endpoints.dart';

class HomeChangeNotifier extends ChangeNotifier {
  final homeRepository = HomeRepository();
  final categoryRepository = CategoryRepository();
  final productRepository = ProductRepository();
  final localStorageRepository = LocalStorageRepository();
  final brandRepository = BrandRepository();

  SliderImageEntity megaBanner;
  String message;

  changeLanguage() {
    print("changeLanguage");
    loadSliderImages();
    getFeaturedCategoriesList();
    loadBestDeals();
    getHomeCategories();
    loadMegaBanner();
    loadNewArrivalsBanner();
    loadNewArrivals();
    loadExculisiveBanner();
    loadOrientalProducts();
    loadFaceCare();
    loadFragrancesBanner();
    loadPerfumes();
    loadBestWatches();
    loadAds();
    getViewedProducts();
    loadGrooming();
    loadSmartTech();
    getCategoriesList();
    getBrandsList('home');
  }

  List<SliderImageEntity> sliderImages = [];
  Future loadSliderImages() async {
    try {
      final result = await homeRepository.getHomeSliderImages(Preload.language);
      if (result['code'] == 'SUCCESS') {
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
    final result = await categoryRepository.getFeaturedCategories(Preload.language);
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
  Future updateBestDealProduct(int index) async {
    String productId = bestDealsProducts[index].productId;
    final product = await productRepository.getProduct(productId);
    bestDealsProducts[index] = product;
    notifyListeners();
  }

  Future loadBestDeals() async {
    try {
      final result = await productRepository.getBestDealsProducts(Preload.language);
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
    // await getHomeCategories();
    notifyListeners();
  }

  Future getHomeCategories() async {
    final params = {'lang': Preload.language};
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
      final result = await homeRepository.getPopupItem(Preload.language);
      if (result['code'] == 'SUCCESS') {
        popupItem = SliderImageEntity.fromJson(result['data'][0]);
        onSuccess(popupItem);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future loadMegaBanner() async {
    final result = await homeRepository.getHomeMegaBanner(Preload.language);
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

  String sunglassesTitle = '';
  List<SliderImageEntity> sunglassesBanners = [];
  List<ProductModel> sunglassesItems = [];
  SliderImageEntity sunglassesViewAll;
  Future loadNewArrivalsBanner() async {
    try {
      final result = await homeRepository.getHomeSection(Preload.language, EndPoints.homeSection3);
      if (result['code'] == 'SUCCESS') {
        sunglassesTitle = result['title'];
        sunglassesViewAll = result['viewAll'];
        sunglassesItems = result['products'];
        sunglassesBanners = result['banners'];
      } else {
        sunglassesTitle = '';
        sunglassesViewAll = null;
        sunglassesItems = [];
        sunglassesBanners = [];
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  List<ProductModel> newArrivalsProducts = [];
  String newArrivalsTitle = '';
  Future updateNewArrivalsProduct(int index) async {
    String productId = newArrivalsProducts[index].productId;
    final product = await productRepository.getProduct(productId);
    newArrivalsProducts[index] = product;
    notifyListeners();
  }

  Future loadNewArrivals() async {
    try {
      final result = await productRepository.getNewArrivalsProducts(Preload.language);
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

  List<SliderImageEntity> exculisiveBanners;
  Future loadExculisiveBanner() async {
    final result = await homeRepository.getHomeExculisiveBanner(Preload.language);
    try {
      if (result['code'] == 'SUCCESS') {
        exculisiveBanners = [];
        List<dynamic> data = result['data'];
        for (var item in data) {
          exculisiveBanners.add(SliderImageEntity.fromJson(item));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  List<ProductModel> orientalProducts = [];
  CategoryEntity orientalCategory;
  String orientalTitle = '';
  Future updateOrientalProduct(int index) async {
    String productId = orientalProducts[index].productId;
    final product = await productRepository.getProduct(productId);
    orientalProducts[index] = product;
    notifyListeners();
  }

  Future loadOrientalProducts() async {
    try {
      final result = await productRepository.getOrientalProducts(Preload.language);
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

  String faceCareTitle = '';
  SliderImageEntity faceCareViewAll;
  List<ProductModel> faceCareProducts = [];
  List<SliderImageEntity> faceCareBanners = [];
  Future loadFaceCare() async {
    try {
      final result = await homeRepository.getHomeSection(Preload.language, EndPoints.homeSection1);
      if (result['code'] == 'SUCCESS') {
        faceCareTitle = result['title'];
        faceCareViewAll = result['viewAll'];
        faceCareProducts = result['products'];
        faceCareBanners = result['banners'];
      } else {
        faceCareTitle = '';
        faceCareViewAll = null;
        faceCareProducts = [];
        faceCareBanners = [];
      }
    } catch (e) {
      print('Face Care');
      print(e.toString());
    }
    notifyListeners();
  }

  String fragrancesBannersTitle = '';
  List<SliderImageEntity> fragrancesBanners = [];
  Future loadFragrancesBanner() async {
    try {
      final result = await homeRepository.getHomeFragrancesBanners(Preload.language);
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
  Future updatePerfumesProduct(int index) async {
    String productId = perfumesProducts[index].productId;
    final product = await productRepository.getProduct(productId);
    perfumesProducts[index] = product;
    notifyListeners();
  }

  Future loadPerfumes() async {
    try {
      final result = await productRepository.getPerfumesProducts(Preload.language);
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

  String bestWatchesTitle = '';
  List<SliderImageEntity> bestWatchesBanners = [];
  List<ProductModel> bestWatchesItems = [];
  SliderImageEntity bestWatchesViewAll;
  Future updateBestWatchesProduct(int index) async {
    String productId = bestWatchesItems[index].productId;
    final product = await productRepository.getProduct(productId);
    bestWatchesItems[index] = product;
    notifyListeners();
  }

  Future loadBestWatches() async {
    try {
      final result = await homeRepository.getHomeSection(
          Preload.language, EndPoints.homeSection2);
      if (result['code'] == 'SUCCESS') {
        bestWatchesTitle = result['title'];
        bestWatchesViewAll = result['viewAll'];
        bestWatchesItems = result['products'];
        bestWatchesBanners = result['banners'];
      } else {
        bestWatchesTitle = '';
        bestWatchesViewAll = null;
        bestWatchesItems = [];
        bestWatchesBanners = [];
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  String celebrityTitle = '';
  List<dynamic> celebrityItems = [];
  Future gethomecelebrity() async {
    try {
      print('gethomecelebrity start');
      final result = await homeRepository.gethomecelebrity(Preload.language, EndPoints.gethomecelebrity);
      print('celebri result');
      print(result);
      log('gethomecelebrity end');
      if (result['code'] == 'SUCCESS') {
        celebrityItems = result['data'];
        celebrityTitle = result['title'];
      } else {
        celebrityTitle = '';
        celebrityItems = [];
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  List<SliderImageEntity> skinCareBanners = [];
  List<ProductModel> skinCareItems = [];
  String skinCareTitle = '';
  SliderImageEntity skinCareViewAll;
  Future loadAds() async {
    try {
      final result = await homeRepository.getHomeSection(
          Preload.language, EndPoints.homeSection4);
      if (result['code'] == 'SUCCESS') {
        skinCareTitle = result['title'];
        skinCareViewAll = result['viewAll'];
        skinCareItems = result['products'];
        skinCareBanners = result['banners'];
      } else {
        skinCareTitle = '';
        skinCareViewAll = null;
        skinCareItems = [];
        skinCareBanners = [];
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future getViewedProducts() async {
    await Preload.currentUser;
    if (user?.token != null) {
      await loadRecentlyViewedCustomer();
    } else {
      await loadRecentlyViewedGuest();
    }
  }

  List<ProductModel> recentlyViewedProducts = [];
  Future updateRecentlyViewedProduct(int index) async {
    String productId = recentlyViewedProducts[index].productId;
    final product = await productRepository.getProduct(productId);
    recentlyViewedProducts[index] = product;
    notifyListeners();
  }

  Future loadRecentlyViewedGuest() async {
    List<String> ids = await localStorageRepository.getRecentlyViewedIds();
    try {
      final result = await productRepository.getHomeRecentlyViewedGuestProducts(ids, Preload.language);
      if (result['code'] == 'SUCCESS') {
        recentlyViewedProducts.clear();
        for (int i = 0; i < result['items'].length; i++) {
          recentlyViewedProducts.add(ProductModel.fromJson(result['items'][i]));
        }
      }
    } catch (e) {
      print('error guest');
      print(e.toString());
    }

    notifyListeners();
  }

  Future loadRecentlyViewedCustomer() async {
    try {
      final result = await productRepository.getHomeRecentlyViewedCustomerProducts(user.token, Preload.language);
      if (result['code'] == 'SUCCESS') {
        recentlyViewedProducts.clear();
        for (int i = 0; i < result['products'].length; i++) {
          recentlyViewedProducts.add(ProductModel.fromJson(result['products'][i]));
        }
      }
    } catch (e) {
      print('error customer');
      print(e.toString());
    }
    notifyListeners();
  }

  List<ProductModel> groomingItems = [];
  List<CategoryEntity> groomingCategories = [];
  String groomingTitle = '';
  CategoryEntity groomingCategory;
  Future loadGrooming() async {
    try {
      final result = await homeRepository.getHomeGrooming(Preload.language);
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
      final result = await homeRepository.getHomeSmartTech(Preload.language);
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
    final result = await categoryRepository.getAllCategories(Preload.language);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> categoryList = result['categories'];
      categories = [];
      for (int i = 0; i < categoryList.length; i++) {
        categories.add(CategoryEntity.fromJson(categoryList[i]));
      }
    }
    notifyListeners();
  }

  List<BrandEntity> brandList = [];
  List<BrandEntity> sortedBrandList = [];
  Future getBrandsList(String from) async {
    final result = await brandRepository.getAllBrands(Preload.language, from);
    _getBrandListFromResult(from, result);
  }

  _getBrandListFromResult(String from, dynamic result) {
    if (result['code'] == 'SUCCESS') {
      List<BrandEntity> brands = [];
      for (int i = 0; i < result['brand'].length; i++) {
        brands.add(BrandEntity.fromJson(result['brand'][i]));
      }
      if (from == 'home') {
        brandList = brands;
      } else {
        sortedBrandList = brands;
      }
    }
    notifyListeners();
  }

  List<BrandEntity> saleBrands = [];
  String saleBrandsTitle = '';
  Future getBrandsOnSale() async {
    saleBrands.clear();
    saleBrandsTitle = '';
    final result = await brandRepository.getBrandsOnSale(Preload.language);
    saleBrands = result['list'];
    saleBrandsTitle = result['title'];
    notifyListeners();
  }
}
