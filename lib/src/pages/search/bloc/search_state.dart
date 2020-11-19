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

class SearchSuggestionLoadedInProcess extends SearchState {}

class SearchSuggestionLoadedSuccess extends SearchState {
  final List<ProductModel> suggestions;

  SearchSuggestionLoadedSuccess({this.suggestions});

  @override
  List<Object> get props => [suggestions];
}

class SearchSuggestionLoadedFailure extends SearchState {
  final String message;

  SearchSuggestionLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}
