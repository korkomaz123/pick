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
    }
  }

  Stream<CategoryState> _mapCategorySubCategoriesLoadedToState(
    String categoryId,
    String lang,
  ) async* {}
}
