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
