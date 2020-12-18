part of 'home_bloc.dart';

class HomeState extends Equatable {
  HomeState({
    this.sliderImages,
    this.bestDealsProducts,
    this.newArrivalsProducts,
    this.perfumesProducts,
    this.message,
    this.ads,
    this.recentlyViewedProducts,
  });

  final List<SliderImageEntity> sliderImages;
  final List<ProductModel> bestDealsProducts;
  final List<ProductModel> newArrivalsProducts;
  final List<ProductModel> perfumesProducts;
  final List<ProductModel> recentlyViewedProducts;
  final String ads;
  final String message;

  HomeState init() {
    return HomeState(
      sliderImages: [],
      bestDealsProducts: [],
      newArrivalsProducts: [],
      perfumesProducts: [],
      recentlyViewedProducts: [],
      ads: '',
      message: '',
    );
  }

  HomeState copyWith({
    List<SliderImageEntity> sliderImages,
    List<ProductModel> bestDealsProducts,
    List<ProductModel> newArrivalsProducts,
    List<ProductModel> perfumesProducts,
    List<ProductModel> recentlyViewedProducts,
    String ads,
    String message,
  }) {
    return HomeState(
      sliderImages: sliderImages ?? this.sliderImages,
      bestDealsProducts: bestDealsProducts ?? this.bestDealsProducts,
      newArrivalsProducts: newArrivalsProducts ?? this.newArrivalsProducts,
      perfumesProducts: perfumesProducts ?? this.perfumesProducts,
      recentlyViewedProducts:
          recentlyViewedProducts ?? this.recentlyViewedProducts,
      ads: ads ?? this.ads,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        sliderImages,
        bestDealsProducts,
        newArrivalsProducts,
        perfumesProducts,
        recentlyViewedProducts,
        ads,
        message,
      ];
}
