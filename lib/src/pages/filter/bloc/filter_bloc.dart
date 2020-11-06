import 'dart:async';

import 'package:bloc/bloc.dart';
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
        yield FilterAttributesLoadedSuccess(availableFilters: availableFilters);
      } else {
        yield FilterAttributesLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield FilterAttributesLoadedFailure(message: e.toString());
    }
  }
}
