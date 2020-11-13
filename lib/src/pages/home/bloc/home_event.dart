part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeSliderImagesLoaded extends HomeEvent {
  final String lang;

  HomeSliderImagesLoaded({this.lang});

  @override
  List<Object> get props => [lang];
}

class HomeBestDealsLoaded extends HomeEvent {
  final String lang;

  HomeBestDealsLoaded({this.lang});

  @override
  List<Object> get props => [lang];
}

class HomeNewArrivalsLoaded extends HomeEvent {
  final String lang;

  HomeNewArrivalsLoaded({this.lang});

  @override
  List<Object> get props => [lang];
}

class HomePerfumesLoaded extends HomeEvent {
  final String lang;

  HomePerfumesLoaded({this.lang});

  @override
  List<Object> get props => [lang];
}

class HomeCategoriesLoaded extends HomeEvent {
  final String lang;

  HomeCategoriesLoaded({this.lang});

  @override
  List<Object> get props => [lang];
}

class HomeBrandsLoaded extends HomeEvent {
  final String lang;

  HomeBrandsLoaded({this.lang});

  @override
  List<Object> get props => [lang];
}
