part of 'category_list_bloc.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();

  @override
  List<Object> get props => [];
}

class CategoryListInitial extends CategoryListState {}

class CategoryListLoadedInProcess extends CategoryListState {}

class CategoryListLoadedSuccess extends CategoryListState {
  final List<CategoryEntity> categories;

  CategoryListLoadedSuccess({this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryListLoadedFailure extends CategoryListState {
  final String message;

  CategoryListLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}
