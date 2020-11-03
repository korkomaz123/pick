import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'brand_repository.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc({@required BrandRepository brandRepository})
      : assert(brandRepository != null),
        _brandRepository = brandRepository,
        super(BrandInitial());

  final BrandRepository _brandRepository;

  @override
  Stream<BrandState> mapEventToState(
    BrandEvent event,
  ) async* {
    if (event is BrandListLoaded) {
      yield* _mapBrandListLoadedToState();
    }
  }

  Stream<BrandState> _mapBrandListLoadedToState() async* {
    yield BrandListLoadedInProcess();
    try {
      final brands = await _brandRepository.getAllBrands();
      yield BrandListLoadedSuccess(brands: brands);
    } catch (e) {
      yield BrandListLoadedFailure(message: e.toString());
    }
  }
}
