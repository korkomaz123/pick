import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({@required CategoryRepository categoryRepository})
      : assert(categoryRepository != null),
        _categoryRepository = categoryRepository,
        super(CategoryInitial());

  final CategoryRepository _categoryRepository;

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is CategorySubCategoriesLoaded) {
      yield* _mapCategorySubCategoriesLoadedToState(
        event.categoryId,
        event.lang,
      );
    } else if (event is CategoryListLoaded) {
      yield* _mapCategoryListLoadedToState(event.lang);
    }
  }

  Stream<CategoryState> _mapCategorySubCategoriesLoadedToState(
    String categoryId,
    String lang,
  ) async* {
    yield CategorySubCategoriesLoadedInProcess();
    try {
      final result =
          await _categoryRepository.getSubCategories(categoryId, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> categoryList = result['categories'];
        List<CategoryEntity> categories = [];
        for (int i = 0; i < categoryList.length; i++) {
          categories.add(CategoryEntity.fromJson(categoryList[i]));
        }
        yield CategorySubCategoriesLoadedSuccess(subCategories: categories);
      } else {
        yield CategorySubCategoriesLoadedFailure(
          message: result['errorMessage'],
        );
      }
    } catch (e) {
      yield CategorySubCategoriesLoadedFailure(message: e.toString());
    }
  }

  Stream<CategoryState> _mapCategoryListLoadedToState(String lang) async* {
    yield CategoryListLoadedInProcess();
    try {
      final categories = await _categoryRepository.getAllCategories(lang);
      yield CategoryListLoadedSuccess(categories: categories);
    } catch (e) {
      yield CategoryListLoadedFailure(message: e.toString());
    }
  }
}
