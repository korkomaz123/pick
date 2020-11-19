part of 'brand_bloc.dart';

abstract class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}

class BrandListLoaded extends BrandEvent {
  final String lang;

  BrandListLoaded({this.lang});

  @override
  List<Object> get props => [lang];
}
