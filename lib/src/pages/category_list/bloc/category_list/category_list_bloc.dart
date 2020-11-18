import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../category_repository.dart';

part 'category_list_event.dart';
part 'category_list_state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListBloc({
    @required CategoryRepository categoryRepository,
  })  : assert(categoryRepository != null),
        _categoryRepository = categoryRepository,
        super(CategoryListInitial());

  final CategoryRepository _categoryRepository;
  final localStorageRepository = LocalStorageRepository();

  @override
  Stream<CategoryListState> mapEventToState(
    CategoryListEvent event,
  ) async* {
    if (event is CategoryListLoaded) {
      yield* _mapCategoryListLoadedToState(event.lang);
    }
  }

  Stream<CategoryListState> _mapCategoryListLoadedToState(String lang) async* {
    yield CategoryListLoadedInProcess();
    try {
      String key = 'categories-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        List<dynamic> categoryList = await localStorageRepository.getItem(key);
        List<CategoryEntity> categories = [];
        for (int i = 0; i < categoryList.length; i++) {
          categories.add(CategoryEntity.fromJson(categoryList[i]));
        }
        yield CategoryListLoadedSuccess(categories: categories);
      }
      final result = await _categoryRepository.getAllCategories(lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['categories']);
        List<dynamic> categoryList = result['categories'];
        List<CategoryEntity> categories = [];
        for (int i = 0; i < categoryList.length; i++) {
          categories.add(CategoryEntity.fromJson(categoryList[i]));
        }
        yield CategoryListLoadedSuccess(categories: categories);
      } else {
        yield CategoryListLoadedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield CategoryListLoadedFailure(message: e.toString());
    }
  }
}
