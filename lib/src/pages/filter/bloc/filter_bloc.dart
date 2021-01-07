import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'filter_repository.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc({@required FilterRepository filterRepository})
      : assert(filterRepository != null),
        _filterRepository = filterRepository,
        super(FilterInitial());

  final FilterRepository _filterRepository;

  @override
  Stream<FilterState> mapEventToState(
    FilterEvent event,
  ) async* {
    if (event is FilterAttributesLoaded) {
      yield* _mapFilterAttributesLoadedToState(event.categoryId, event.lang);
    } else if (event is Filtered) {
      yield* _mapFilteredToState(
        event.categoryIds,
        event.priceRanges,
        event.genders,
        event.colors,
        event.sizes,
        event.brands,
        event.lang,
      );
    } else if (event is FilterInitialized) {
      yield FilterInitial();
    }
  }

  Stream<FilterState> _mapFilterAttributesLoadedToState(
    String categoryId,
    String lang,
  ) async* {
    yield FilterAttributesLoadedInProcess();
    try {
      final result =
          await _filterRepository.getFilterAttributes(categoryId, lang);
      if (result['code'] == 'SUCCESS') {
        final availableFilters =
            result['filter']['availablefilter'] as Map<String, dynamic>;
        result['filter']['prices']['attribute_code'] = 'price';
        availableFilters['Price'] = result['filter']['prices'];
        yield FilterAttributesLoadedSuccess(availableFilters: availableFilters);
      } else {
        yield FilterAttributesLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield FilterAttributesLoadedFailure(message: e.toString());
    }
  }

  Stream<FilterState> _mapFilteredToState(
    List<dynamic> categoryIds,
    List<dynamic> priceRanges,
    List<dynamic> genders,
    List<dynamic> colors,
    List<dynamic> sizes,
    List<dynamic> brands,
    String lang,
  ) async* {
    yield FilteredInProcess();
    try {
      final result = await _filterRepository.filter(
          categoryIds, priceRanges, genders, colors, sizes, brands, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> productList = result['products'];
        List<ProductModel> products = [];
        for (int i = 0; i < productList.length; i++) {
          products.add(ProductModel.fromJson(productList[i]));
        }
        yield FilteredSuccess(products: products);
      } else {
        yield FilteredFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield FilteredFailure(message: e.toString());
    }
  }
}
