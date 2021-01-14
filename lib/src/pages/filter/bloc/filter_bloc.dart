import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'filter_repository.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc({
    @required FilterRepository filterRepository,
    @required LocalStorageRepository localStorageRepository,
  })  : assert(filterRepository != null),
        assert(localStorageRepository != null),
        _filterRepository = filterRepository,
        _localStorageRepository = localStorageRepository,
        super(FilterInitial());

  final FilterRepository _filterRepository;
  final LocalStorageRepository _localStorageRepository;

  @override
  Stream<FilterState> mapEventToState(
    FilterEvent event,
  ) async* {
    if (event is FilterAttributesLoaded) {
      yield* _mapFilterAttributesLoadedToState(
        event.categoryId,
        event.brandId,
        event.lang,
      );
    } else if (event is FilterInitialized) {
      yield FilterInitial();
    }
  }

  Stream<FilterState> _mapFilterAttributesLoadedToState(
    String categoryId,
    String brandId,
    String lang,
  ) async* {
    yield FilterAttributesLoadedInProcess();
    try {
      final key =
          'filter-' + (categoryId ?? '') + '-' + (brandId ?? '') + '-' + lang;
      final existItem = await _localStorageRepository.existItem(key);
      if (existItem) {
        final cacheData = await _localStorageRepository.getItem(key);
        yield FilterAttributesLoadedSuccess(availableFilters: cacheData);
      }
      final result = await _filterRepository.getFilterAttributes(
          categoryId, brandId, lang);
      if (result['code'] == 'SUCCESS') {
        final availableFilters =
            result['filter']['availablefilter'] as Map<String, dynamic>;
        result['filter']['prices']['attribute_code'] = 'price';
        availableFilters['Price'] = result['filter']['prices'];
        await _localStorageRepository.setItem(key, availableFilters);
        if (!existItem) {
          yield FilterAttributesLoadedSuccess(
            availableFilters: availableFilters,
          );
        }
      } else {
        if (!existItem) {
          yield FilterAttributesLoadedFailure(message: result['errMessage']);
        }
      }
    } catch (e) {
      yield FilterAttributesLoadedFailure(message: e.toString());
    }
  }
}
