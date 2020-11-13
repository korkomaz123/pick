part of 'home_bloc.dart';

class HomeState extends Equatable {
  HomeState({
    this.sliderImages,
    this.bestDealsProducts,
    this.newArrivalsProducts,
    this.perfumesProducts,
    this.categories,
    this.brands,
    this.message,
  });

  final List<SliderImageEntity> sliderImages;
  final List<ProductModel> bestDealsProducts;
  final List<ProductModel> newArrivalsProducts;
  final List<ProductModel> perfumesProducts;
  final List<CategoryEntity> categories;
  final List<BrandEntity> brands;
  final String message;

  HomeState init() {
    return HomeState(
      sliderImages: [],
      bestDealsProducts: [],
      newArrivalsProducts: [],
      perfumesProducts: [],
      categories: [],
      brands: [],
      message: '',
    );
  }

  HomeState copyWith({
    List<SliderImageEntity> sliderImages,
    List<ProductModel> bestDealsProducts,
    List<ProductModel> newArrivalsProducts,
    List<ProductModel> perfumesProducts,
    List<CategoryEntity> categories,
    List<BrandEntity> brands,
    String message,
  }) {
    return HomeState(
      sliderImages: sliderImages ?? this.sliderImages,
      bestDealsProducts: bestDealsProducts ?? this.bestDealsProducts,
      newArrivalsProducts: newArrivalsProducts ?? this.newArrivalsProducts,
      perfumesProducts: perfumesProducts ?? this.perfumesProducts,
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        sliderImages,
        bestDealsProducts,
        newArrivalsProducts,
        perfumesProducts,
        categories,
        brands,
        message,
      ];
}
