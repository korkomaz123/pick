part of 'brand_bloc.dart';

abstract class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}

class BrandListLoaded extends BrandEvent {
  final String lang;
  final String from;

  BrandListLoaded({this.lang, this.from});

  @override
  List<Object> get props => [lang, from];
}
