import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/data/models/slider_image_entity.dart';
import 'package:ciga/src/pages/brand_list/bloc/brand_repository.dart';
import 'package:ciga/src/pages/category_list/bloc/category_repository.dart';
import 'package:ciga/src/pages/product/bloc/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    @required HomeRepository homeRepository,
    @required CategoryRepository categoryRepository,
    @required BrandRepository brandRepository,
    @required ProductRepository productRepository,
  })  : assert(homeRepository != null),
        assert(categoryRepository != null),
        assert(brandRepository != null),
        assert(productRepository != null),
        _homeRepository = homeRepository,
        _categoryRepository = categoryRepository,
        _brandRepository = brandRepository,
        _productRepository = productRepository,
        super(HomeState().init());

  final HomeRepository _homeRepository;
  final CategoryRepository _categoryRepository;
  final BrandRepository _brandRepository;
  final ProductRepository _productRepository;

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
    } else if (event is HomeCategoriesLoaded) {
      yield* _mapHomeCategoriesLoadedToState(event.lang);
    } else if (event is HomeBrandsLoaded) {
      yield* _mapHomeBrandsLoadedToState(event.lang);
    } else if (event is HomeAdsLoaded) {
      yield* _mapHomeAdsLoadedToState();
    }
  }

  Stream<HomeState> _mapHomeSliderImagesLoadedToState(String lang) async* {
    try {
      final sliderImages = await _homeRepository.getHomeSliderImages();

      yield state.copyWith(sliderImages: sliderImages);
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeBestDealsLoadedToState(String lang) async* {
    try {
      final bestDeals = await _productRepository.getBestDealsProducts(lang);

      yield state.copyWith(bestDealsProducts: bestDeals);
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapNewArrivalsLoadedToState(String lang) async* {
    try {
      final newArrivals = await _productRepository.getNewArrivalsProducts(lang);

      yield state.copyWith(newArrivalsProducts: newArrivals);
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomePerfumesLoadedToState(String lang) async* {
    try {
      final perfumes = await _productRepository.getPerfumesProducts(lang);

      yield state.copyWith(perfumesProducts: perfumes);
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeCategoriesLoadedToState(String lang) async* {
    try {
      final categories = await _categoryRepository.getAllCategories(lang);

      yield state.copyWith(categories: categories);
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeBrandsLoadedToState(String lang) async* {
    try {
      final brands = await _brandRepository.getAllBrands();

      yield state.copyWith(brands: brands);
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }

  Stream<HomeState> _mapHomeAdsLoadedToState() async* {
    try {
      final ads = await _homeRepository.getHomeAds();

      yield state.copyWith(ads: ads);
    } catch (e) {
      yield state.copyWith(message: e.toString());
    }
  }
}
