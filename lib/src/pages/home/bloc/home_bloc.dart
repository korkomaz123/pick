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
        super(HomeInitial());

  final HomeRepository _homeRepository;
  final CategoryRepository _categoryRepository;
  final BrandRepository _brandRepository;
  final ProductRepository _productRepository;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeDataFetched) {
      yield* _mapHomeDataFetchedToState(event.lang);
    }
  }

  Stream<HomeState> _mapHomeDataFetchedToState(String lang) async* {
    yield HomeDataFetchedInProcess();
    try {
      final sliderImages = await _homeRepository.getHomeSliderImages();
      final bestDeals = await _productRepository.getBestDealsProducts(lang);
      final newArrivals = await _productRepository.getNewArrivalsProducts(lang);
      final perfumes = await _productRepository.getPerfumesProducts(lang);
      final categories = await _categoryRepository.getAllCategories(lang);
      final brands = await _brandRepository.getAllBrands();
      yield HomeDataFetchedSuccess(
        sliderImages: sliderImages,
        bestDealsProducts: bestDeals,
        newArrivalsProducts: newArrivals,
        perfumesProducts: perfumes,
        categories: categories,
        brands: brands,
      );
    } catch (e) {
      yield HomeDataFetchedFailure(message: e.toString());
    }
  }
}
