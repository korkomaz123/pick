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
