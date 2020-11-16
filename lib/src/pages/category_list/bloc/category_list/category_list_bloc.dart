import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/category_entity.dart';
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
      final categories = await _categoryRepository.getAllCategories(lang);
      yield CategoryListLoadedSuccess(categories: categories);
    } catch (e) {
      yield CategoryListLoadedFailure(message: e.toString());
    }
  }
}
