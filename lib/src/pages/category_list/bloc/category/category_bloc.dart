import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/pages/brand_list/bloc/brand_repository.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({
    @required CategoryRepository categoryRepository,
    @required BrandRepository brandRepository,
  })  : assert(categoryRepository != null),
        assert(brandRepository != null),
        _categoryRepository = categoryRepository,
        _brandRepository = brandRepository,
        super(CategoryInitial());

  final CategoryRepository _categoryRepository;
  final BrandRepository _brandRepository;
  final LocalStorageRepository localStorageRepository =
      LocalStorageRepository();

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is CategorySubCategoriesLoaded) {
      yield* _mapCategorySubCategoriesLoadedToState(
        event.categoryId,
        event.lang,
      );
    } else if (event is BrandSubCategoriesLoaded) {
      yield* _mapBrandSubCategoriesLoadedToState(event.brandId, event.lang);
    } else if (event is CategoryInitialized) {
      yield CategoryInitial();
    }
  }

  Stream<CategoryState> _mapCategorySubCategoriesLoadedToState(
    String categoryId,
    String lang,
  ) async* {
    yield CategorySubCategoriesLoadedInProcess();
    try {
      String key = 'cat-subCat-$categoryId-$lang';
      final isCached = await localStorageRepository.existItem(key);
      if (isCached) {
        List<dynamic> categoryList = await localStorageRepository.getItem(key);
        List<CategoryEntity> categories = [];
        for (int i = 0; i < categoryList.length; i++) {
          categories.add(CategoryEntity.fromJson(categoryList[i]));
        }
        yield CategorySubCategoriesLoadedSuccess(subCategories: categories);
      }
      final result =
          await _categoryRepository.getSubCategories(categoryId, lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['categories']);
        List<dynamic> categoryList = result['categories'];
        List<CategoryEntity> categories = [];
        for (int i = 0; i < categoryList.length; i++) {
          categories.add(CategoryEntity.fromJson(categoryList[i]));
        }
        yield CategorySubCategoriesLoadedSuccess(subCategories: categories);
      } else {
        yield CategorySubCategoriesLoadedFailure(
          message: result['errMessage'],
        );
      }
    } catch (e) {
      yield CategorySubCategoriesLoadedFailure(message: e.toString());
    }
  }

  Stream<CategoryState> _mapBrandSubCategoriesLoadedToState(
    String brandId,
    String lang,
  ) async* {
    yield CategorySubCategoriesLoadedInProcess();
    try {
      final result = await _brandRepository.getBrandCategories(brandId, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> categoryList = result['categories'];
        List<CategoryEntity> categories = [];
        for (int i = 0; i < categoryList.length; i++) {
          categories.add(CategoryEntity.fromJson(categoryList[i]));
        }
        yield CategorySubCategoriesLoadedSuccess(subCategories: categories);
      } else {
        yield CategorySubCategoriesLoadedFailure(
          message: result['errMessage'],
        );
      }
    } catch (e) {
      yield CategorySubCategoriesLoadedFailure(
        message: e.toString(),
      );
    }
  }
}
