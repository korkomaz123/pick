import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
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
  final localStorageRepository = LocalStorageRepository();

  @override
  Stream<BrandState> mapEventToState(
    BrandEvent event,
  ) async* {
    if (event is BrandListLoaded) {
      yield* _mapBrandListLoadedToState(event.lang);
    }
  }

  Stream<BrandState> _mapBrandListLoadedToState(String lang) async* {
    yield BrandListLoadedInProcess();
    try {
      String key = 'brands';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        List<dynamic> brandList = await localStorageRepository.getItem(key);
        List<BrandEntity> brands = [];
        for (int i = 0; i < brandList.length; i++) {
          brands.add(BrandEntity.fromJson(brandList[i]));
        }
        yield BrandListLoadedSuccess(brands: brands);
      }
      final result = await _brandRepository.getAllBrands(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['brand']);
        List<dynamic> brandList = result['brand'];
        List<BrandEntity> brands = [];
        for (int i = 0; i < brandList.length; i++) {
          brands.add(BrandEntity.fromJson(brandList[i]));
        }
        yield BrandListLoadedSuccess(brands: brands);
      } else {
        yield BrandListLoadedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield BrandListLoadedFailure(message: e.toString());
    }
  }
}
