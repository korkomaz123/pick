import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/search/bloc/search_repository.dart';
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
    }
  }

  Stream<SearchState> _mapSearchedToState(
    String query,
    String categories,
    String brands,
    String genders,
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
        yield SearchedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield SearchedFailure(message: e.toString());
    }
  }
}
