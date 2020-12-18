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

class HomeAdsLoaded extends HomeEvent {}

class HomeRecentlyViewedGuestLoaded extends HomeEvent {
  final List<String> ids;
  final String lang;

  HomeRecentlyViewedGuestLoaded({this.ids, this.lang});

  @override
  List<Object> get props => [ids, lang];
}

class HomeRecentlyViewedCustomerLoaded extends HomeEvent {
  final String token;
  final String lang;

  HomeRecentlyViewedCustomerLoaded({this.token, this.lang});

  @override
  List<Object> get props => [token, lang];
}
