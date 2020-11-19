part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class FilterAttributesLoaded extends FilterEvent {
  final String categoryId;
  final String lang;

  FilterAttributesLoaded({this.categoryId, this.lang});

  @override
  List<Object> get props => [categoryId, lang];
}

class Filtered extends FilterEvent {
  final List<dynamic> categoryIds;
  final List<dynamic> priceRanges;
  final List<dynamic> genders;
  final List<dynamic> sizes;
  final List<dynamic> colors;
  final List<dynamic> brands;
  final String lang;

  Filtered({
    this.categoryIds,
    this.priceRanges,
    this.genders,
    this.sizes,
    this.colors,
    this.brands,
    this.lang,
  });

  @override
  List<Object> get props => [
        categoryIds,
        priceRanges,
        genders,
        sizes,
        colors,
        brands,
        lang,
      ];
}

class FilterInitialized extends FilterEvent {}
