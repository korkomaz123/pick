part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class FilterAttributesLoaded extends FilterEvent {
  final String categoryId;
  final String brandId;
  final String lang;

  FilterAttributesLoaded({this.categoryId, this.brandId, this.lang});

  @override
  List<Object> get props => [categoryId, brandId, lang];
}

class FilterInitialized extends FilterEvent {}
