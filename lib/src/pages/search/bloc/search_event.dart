part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class Searched extends SearchEvent {
  final String query;
  final String categories;
  final String brands;
  final String genders;
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
