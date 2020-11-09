part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchedInProcess extends SearchState {}

class SearchedSuccess extends SearchState {
  final List<ProductModel> products;

  SearchedSuccess({this.products});

  @override
  List<Object> get props => [products];
}

class SearchedFailure extends SearchState {
  final String message;

  SearchedFailure({this.message});

  @override
  List<Object> get props => [message];
}
