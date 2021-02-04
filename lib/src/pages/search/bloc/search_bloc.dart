import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/search/bloc/search_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({@required SearchRepository searchRepository})
      : assert(searchRepository != null),
        _searchRepository = searchRepository,
        super(SearchInitial());

  final SearchRepository _searchRepository;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is Searched) {
      yield* _mapSearchedToState(
        event.query,
        event.categories,
        event.brands,
        event.genders,
        event.lang,
      );
    } else if (event is SearchInitialized) {
      yield SearchInitial();
    } else if (event is SearchSuggestionLoaded) {
      yield* _mapSearchSuggestionLoadedToState(event.query, event.lang);
    }
  }

  Stream<SearchState> _mapSearchedToState(
    String query,
    List<dynamic> categories,
    List<dynamic> brands,
    List<dynamic> genders,
    String lang,
  ) async* {
    yield SearchedInProcess();
    try {
      final result = await _searchRepository.searchProducts(
          query, categories, brands, genders, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> productList = result['products'];
        List<ProductModel> products = [];
        for (int i = 0; i < productList.length; i++) {
          products.add(ProductModel.fromJson(productList[i]));
        }
        yield SearchedSuccess(products: products);
      } else {
        print(result['errMessage']);
        yield SearchedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield SearchedFailure(message: e.toString());
    }
  }

  Stream<SearchState> _mapSearchSuggestionLoadedToState(
    String query,
    String lang,
  ) async* {
    yield SearchSuggestionLoadedInProcess();
    try {
      // final result = await _searchRepository.getSearchSuggestion(query, lang);
      // if (result['code'] == 'SUCCESS') {
      //   List<dynamic> suggestionList = result['products'];
      //   List<ProductModel> suggestions = [];
      //   for (int i = 0; i < suggestionList.length; i++) {
      //     suggestions.add(ProductModel.fromJson(suggestionList[i]));
      //   }
      //   yield SearchSuggestionLoadedSuccess(suggestions: suggestions);
      // } else {
      //   yield SearchSuggestionLoadedFailure(message: result['errorMessage']);
      // }
    } catch (e) {
      yield SearchSuggestionLoadedFailure(message: e.toString());
    }
  }
}
