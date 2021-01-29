import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/pages/product/bloc/product_repository.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    @required HomeRepository homeRepository,
    @required ProductRepository productRepository,
  })  : assert(homeRepository != null),
        assert(productRepository != null),
        _homeRepository = homeRepository,
        _productRepository = productRepository,
        super(HomeState().init());

  final HomeRepository _homeRepository;
  final ProductRepository _productRepository;
  final localStorageRepository = LocalStorageRepository();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeSliderImagesLoaded) {
      yield* _mapHomeSliderImagesLoadedToState(event.lang);
    } else if (event is HomeBestDealsLoaded) {
      yield* _mapHomeBestDealsLoadedToState(event.lang);
    } else if (event is HomeNewArrivalsLoaded) {
      yield* _mapNewArrivalsLoadedToState(event.lang);
    } else if (event is HomePerfumesLoaded) {
      yield* _mapHomePerfumesLoadedToState(event.lang);
    } else if (event is HomeAdsLoaded) {
      yield* _mapHomeAdsLoadedToState();
    } else if (event is HomeRecentlyViewedGuestLoaded) {
      yield* _mapHomeRecentlyViewedGuestLoadedToState(event.ids, event.lang);
    } else if (event is HomeRecentlyViewedCustomerLoaded) {
      yield* _mapHomeRecentlyViewedCustomerLoadedToState(
        event.token,
        event.lang,
      );
    } else if (event is HomeBestDealsBannersLoaded) {
      yield* _mapHomeBestDealsBannersLoadedToState(event.lang);
    } else if (event is HomeNewArrivalsBannersLoaded) {
      yield* _mapHomeNewArrivalsBannersLoadedToState(event.lang);
    }
  }

  Stream<HomeState> _mapHomeSliderImagesLoadedToState(String lang) async* {
    try {
      String key = 'slider-images-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        List<dynamic> sliderImageList =
            await localStorageRepository.getItem(key);
        List<SliderImageEntity> sliderImages = [];
        for (int i = 0; i < sliderImageList.length; i++) {
          sliderImages.add(SliderImageEntity.fromJson(sliderImageList[i]));
        }
        yield state.copyWith(sliderImages: sliderImages);
      }
      final result = await _homeRepository.getHomeSliderImages(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['data']);
        List<dynamic> sliderImageList = result['data'];
        List<SliderImageEntity> sliderImages = [];
        for (int i = 0; i < sliderImageList.length; i++) {
          sliderImages.add(SliderImageEntity.fromJson(sliderImageList[i]));
        }
        yield state.copyWith(sliderImages: sliderImages);
      } else {
        yield state.copyWith(message: result['errorMessage']);
      }
    } catch (e) {
      print(e.toString());
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeBestDealsLoadedToState(String lang) async* {
    try {
      String key = 'bestdeals-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        String title = await localStorageRepository.getItem(key + 'title');
        List<dynamic> bestDealsList = await localStorageRepository.getItem(key);
        List<ProductModel> bestDeals = [];
        for (int i = 0; i < bestDealsList.length; i++) {
          bestDeals.add(ProductModel.fromJson(bestDealsList[i]));
        }
        yield state.copyWith(
          bestDealsProducts: bestDeals,
          bestDealsTitle: title,
        );
      }
      final result = await _productRepository.getBestDealsProducts(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['products']);
        await localStorageRepository.setItem(key + 'title', result['title']);
        List<dynamic> bestDealsList = result['products'];
        List<ProductModel> bestDeals = [];
        for (int i = 0; i < bestDealsList.length; i++) {
          bestDeals.add(ProductModel.fromJson(bestDealsList[i]));
        }
        yield state.copyWith(
          bestDealsProducts: bestDeals,
          bestDealsTitle: result['title'],
        );
      } else {
        yield state.copyWith(message: result['errorMessage']);
      }
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapNewArrivalsLoadedToState(String lang) async* {
    try {
      String key = 'newarrivals-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        String title = await localStorageRepository.getItem(key + 'title');
        List<dynamic> newArrivalsList =
            await localStorageRepository.getItem(key);
        List<ProductModel> newArrivals = [];
        for (int i = 0; i < newArrivalsList.length; i++) {
          newArrivals.add(ProductModel.fromJson(newArrivalsList[i]));
        }
        yield state.copyWith(
          newArrivalsProducts: newArrivals,
          newArrivalsTitle: title,
        );
      }
      final result = await _productRepository.getNewArrivalsProducts(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['products']);
        await localStorageRepository.setItem(key + 'title', result['title']);
        List<dynamic> newArrivalsList = result['products'];
        List<ProductModel> newArrivals = [];
        for (int i = 0; i < newArrivalsList.length; i++) {
          newArrivals.add(ProductModel.fromJson(newArrivalsList[i]));
        }
        yield state.copyWith(
          newArrivalsProducts: newArrivals,
          newArrivalsTitle: result['title'],
        );
      } else {
        yield state.copyWith(message: result['errorMessage']);
      }
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomePerfumesLoadedToState(String lang) async* {
    try {
      String key = 'perfumes-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        String title = await localStorageRepository.getItem(key + 'title');
        List<dynamic> perfumesList = await localStorageRepository.getItem(key);
        List<ProductModel> perfumes = [];
        for (int i = 0; i < perfumesList.length; i++) {
          perfumes.add(ProductModel.fromJson(perfumesList[i]));
        }
        yield state.copyWith(
          perfumesProducts: perfumes,
          perfumesTitle: title,
        );
      }
      final result = await _productRepository.getPerfumesProducts(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['products']);
        await localStorageRepository.setItem(key + 'title', result['title']);
        List<dynamic> perfumesList = result['products'];
        List<ProductModel> perfumes = [];
        for (int i = 0; i < perfumesList.length; i++) {
          perfumes.add(ProductModel.fromJson(perfumesList[i]));
        }
        yield state.copyWith(
          perfumesProducts: perfumes,
          perfumesTitle: result['title'],
        );
      } else {
        yield state.copyWith(message: result['errorMessage']);
      }
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeAdsLoadedToState() async* {
    try {
      String key = 'homeads';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        String ads = await localStorageRepository.getItem(key);
        yield state.copyWith(ads: ads);
      }
      final ads = await _homeRepository.getHomeAds();
      await localStorageRepository.setItem(key, ads);
      yield state.copyWith(ads: ads);
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeRecentlyViewedGuestLoadedToState(
    List<String> ids,
    String lang,
  ) async* {
    try {
      final result = await _productRepository
          .getHomeRecentlyViewedGuestProducts(ids, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> recentlyViewedList = result['items'];
        List<ProductModel> recentlyViewedProducts = [];
        for (int i = 0; i < recentlyViewedList.length; i++) {
          recentlyViewedProducts
              .add(ProductModel.fromJson(recentlyViewedList[i]));
        }
        yield state.copyWith(recentlyViewedProducts: recentlyViewedProducts);
      } else {
        yield state.copyWith(message: result['errorMessage']);
      }
    } catch (e) {
      print('error guest');
      print(e.toString());
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeRecentlyViewedCustomerLoadedToState(
    String token,
    String lang,
  ) async* {
    try {
      final result = await _productRepository
          .getHomeRecentlyViewedCustomerProducts(token, lang);
      // print(result);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> recentlyViewedList = result['products'];
        List<ProductModel> recentlyViewedProducts = [];
        for (int i = 0; i < recentlyViewedList.length; i++) {
          recentlyViewedProducts
              .add(ProductModel.fromJson(recentlyViewedList[i]));
        }
        yield state.copyWith(recentlyViewedProducts: recentlyViewedProducts);
      } else {
        yield state.copyWith(message: result['errorMessage']);
      }
    } catch (e) {
      print('error customer');
      print(e.toString());
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeBestDealsBannersLoadedToState(
    String lang,
  ) async* {
    try {
      String key = 'best-deals-banners-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        Map<String, dynamic> data = await localStorageRepository.getItem(key);
        String title = data['title'];
        List<dynamic> sliderImageList = data['banners'];
        List<SliderImageEntity> sliderImages = [];
        for (int i = 0; i < sliderImageList.length; i++) {
          sliderImages.add(SliderImageEntity.fromJson(sliderImageList[i]));
        }
        yield state.copyWith(
          bestDealsBanners: sliderImages,
          bestDealsBannerTitle: title,
        );
      }
      final result = await _homeRepository.getHomeBestDealsBanners(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(
          key,
          {'title': result['title'], 'banners': result['data']},
        );
        String title = result['title'];
        List<dynamic> sliderImageList = result['data'];
        List<SliderImageEntity> sliderImages = [];
        for (int i = 0; i < sliderImageList.length; i++) {
          sliderImages.add(SliderImageEntity.fromJson(sliderImageList[i]));
        }
        yield state.copyWith(
          bestDealsBanners: sliderImages,
          bestDealsBannerTitle: title,
        );
      } else {
        yield state.copyWith(message: result['errorMessage']);
      }
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeNewArrivalsBannersLoadedToState(
    String lang,
  ) async* {
    try {
      String key = 'new-arrivals-banners-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        Map<String, dynamic> data = await localStorageRepository.getItem(key);
        String title = data['title'];
        List<dynamic> sliderImageList = data['banners'];
        List<SliderImageEntity> sliderImages = [];
        for (int i = 0; i < sliderImageList.length; i++) {
          sliderImages.add(SliderImageEntity.fromJson(sliderImageList[i]));
        }
        yield state.copyWith(
          newArrivalsBanners: sliderImages,
          newArrivalsBannerTitle: title,
        );
      }
      final result = await _homeRepository.getHomeNewArrivalsBanners(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(
          key,
          {'title': result['title'], 'banners': result['data']},
        );
        String title = result['title'];
        List<dynamic> sliderImageList = result['data'];
        List<SliderImageEntity> sliderImages = [];
        for (int i = 0; i < sliderImageList.length; i++) {
          sliderImages.add(SliderImageEntity.fromJson(sliderImageList[i]));
        }
        yield state.copyWith(
          newArrivalsBanners: sliderImages,
          newArrivalsBannerTitle: title,
        );
      } else {
        yield state.copyWith(message: result['errorMessage']);
      }
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }
}
