part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchInitialized extends SearchEvent {}

class Searched extends SearchEvent {
  final String query;
  final List<dynamic> categories;
  final List<dynamic> brands;
  final List<dynamic> genders;
  final String lang;

  Searched({
    this.query,
    this.categories,
    this.brands,
    this.genders,
    this.lang,
  });

  @override
  List<Object> get props => [
        query,
        categories,
        brands,
        genders,
        lang,
      ];
}
