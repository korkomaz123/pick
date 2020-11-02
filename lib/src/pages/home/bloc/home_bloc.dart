import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/data/models/slider_image_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({@required HomeRepository homeRepository})
      : assert(homeRepository != null),
        _homeRepository = homeRepository,
        super(HomeInitial());

  final HomeRepository _homeRepository;

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
      final bestDeals = await _homeRepository.getBestDealsProducts(lang);
      final newArrivals = await _homeRepository.getNewArrivalsProducts(lang);
      final perfumes = await _homeRepository.getPerfumesProducts(lang);
      final categories = await _homeRepository.getAllCategories(lang);
      final brands = await _homeRepository.getAllBrands();
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
