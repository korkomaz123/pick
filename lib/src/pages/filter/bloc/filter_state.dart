part of 'filter_bloc.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

class FilterInitial extends FilterState {}

class FilterAttributesLoadedInProcess extends FilterState {}

class FilterAttributesLoadedSuccess extends FilterState {
  final Map<String, dynamic> availableFilters;

  FilterAttributesLoadedSuccess({this.availableFilters});

  @override
  List<Object> get props => [availableFilters];
}

class FilterAttributesLoadedFailure extends FilterState {
  final String message;

  FilterAttributesLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}

class FilteredInProcess extends FilterState {}

class FilteredSuccess extends FilterState {
  final List<ProductModel> products;

  FilteredSuccess({this.products});

  @override
  List<Object> get props => [products];
}

class FilteredFailure extends FilterState {
  final String message;

  FilteredFailure({this.message});

  @override
  List<Object> get props => [message];
}
