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
    this.bestDealsTitle,
    this.newArrivalsTitle,
    this.perfumesTitle,
  });

  final List<SliderImageEntity> sliderImages;
  final List<ProductModel> bestDealsProducts;
  final List<ProductModel> newArrivalsProducts;
  final List<ProductModel> perfumesProducts;
  final List<ProductModel> recentlyViewedProducts;
  final String ads;
  final String message;
  final String bestDealsTitle;
  final String newArrivalsTitle;
  final String perfumesTitle;

  HomeState init() {
    return HomeState(
      sliderImages: [],
      bestDealsProducts: [],
      newArrivalsProducts: [],
      perfumesProducts: [],
      recentlyViewedProducts: [],
      ads: '',
      message: '',
      bestDealsTitle: '',
      newArrivalsTitle: '',
      perfumesTitle: '',
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
    String bestDealsTitle,
    String newArrivalsTitle,
    String perfumesTitle,
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
      bestDealsTitle: bestDealsTitle ?? this.bestDealsTitle,
      newArrivalsTitle: newArrivalsTitle ?? this.newArrivalsTitle,
      perfumesTitle: perfumesTitle ?? this.perfumesTitle,
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
        bestDealsTitle,
        newArrivalsTitle,
        perfumesTitle,
      ];
}
