part of 'home_bloc.dart';

class HomeState extends Equatable {
  HomeState({
    this.sliderImages,
    this.bestDealsBanners,
    this.newArrivalsBanners,
    this.bestDealsProducts,
    this.newArrivalsProducts,
    this.perfumesProducts,
    this.message,
    this.ads,
    this.recentlyViewedProducts,
    this.bestDealsTitle,
    this.newArrivalsTitle,
    this.perfumesTitle,
    this.newArrivalsBannerTitle,
    this.bestDealsBannerTitle,
  });

  final List<SliderImageEntity> sliderImages;
  final List<SliderImageEntity> newArrivalsBanners;
  final List<SliderImageEntity> bestDealsBanners;
  final List<ProductModel> bestDealsProducts;
  final List<ProductModel> newArrivalsProducts;
  final List<ProductModel> perfumesProducts;
  final List<ProductModel> recentlyViewedProducts;
  final SliderImageEntity ads;
  final String message;
  final String bestDealsTitle;
  final String newArrivalsTitle;
  final String perfumesTitle;
  final String bestDealsBannerTitle;
  final String newArrivalsBannerTitle;

  HomeState init() {
    return HomeState(
      sliderImages: [],
      bestDealsBanners: [],
      newArrivalsBanners: [],
      bestDealsProducts: [],
      newArrivalsProducts: [],
      perfumesProducts: [],
      recentlyViewedProducts: [],
      ads: null,
      message: '',
      bestDealsTitle: '',
      newArrivalsTitle: '',
      perfumesTitle: '',
      bestDealsBannerTitle: '',
      newArrivalsBannerTitle: '',
    );
  }

  HomeState copyWith({
    List<SliderImageEntity> sliderImages,
    List<SliderImageEntity> bestDealsBanners,
    List<SliderImageEntity> newArrivalsBanners,
    List<ProductModel> bestDealsProducts,
    List<ProductModel> newArrivalsProducts,
    List<ProductModel> perfumesProducts,
    List<ProductModel> recentlyViewedProducts,
    SliderImageEntity ads,
    String message,
    String bestDealsTitle,
    String newArrivalsTitle,
    String perfumesTitle,
    String bestDealsBannerTitle,
    String newArrivalsBannerTitle,
  }) {
    return HomeState(
      sliderImages: sliderImages ?? this.sliderImages,
      bestDealsBanners: bestDealsBanners ?? this.bestDealsBanners,
      newArrivalsBanners: newArrivalsBanners ?? this.newArrivalsBanners,
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
      bestDealsBannerTitle: bestDealsBannerTitle ?? this.bestDealsBannerTitle,
      newArrivalsBannerTitle:
          newArrivalsBannerTitle ?? this.newArrivalsBannerTitle,
    );
  }

  @override
  List<Object> get props => [
        sliderImages,
        bestDealsBanners,
        newArrivalsBanners,
        bestDealsProducts,
        newArrivalsProducts,
        perfumesProducts,
        recentlyViewedProducts,
        ads,
        message,
        bestDealsTitle,
        newArrivalsTitle,
        perfumesTitle,
        bestDealsBannerTitle,
        newArrivalsBannerTitle,
      ];
}
