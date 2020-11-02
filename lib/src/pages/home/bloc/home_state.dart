part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeDataFetchedInProcess extends HomeState {}

class HomeDataFetchedSuccess extends HomeState {
  final List<SliderImageEntity> sliderImages;
  final List<ProductModel> bestDealsProducts;
  final List<ProductModel> newArrivalsProducts;
  final List<ProductModel> perfumesProducts;
  final List<CategoryEntity> categories;
  final List<BrandEntity> brands;

  HomeDataFetchedSuccess({
    this.sliderImages,
    this.bestDealsProducts,
    this.newArrivalsProducts,
    this.perfumesProducts,
    this.categories,
    this.brands,
  });

  @override
  List<Object> get props => [
        sliderImages,
        bestDealsProducts,
        newArrivalsProducts,
        perfumesProducts,
        categories,
        brands,
      ];
}

class HomeDataFetchedFailure extends HomeState {
  final String message;

  HomeDataFetchedFailure({this.message});

  @override
  List<Object> get props => [message];
}
