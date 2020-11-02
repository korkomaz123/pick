part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategorySubCategoriesLoadedInProcess extends CategoryState {}

class CategorySubCategoriesLoadedSuccess extends CategoryState {
  final List<CategoryEntity> subCategories;

  CategorySubCategoriesLoadedSuccess({this.subCategories});

  @override
  List<Object> get props => [subCategories];
}

class CategorySubCategoriesLoadedFailure extends CategoryState {
  final String message;

  CategorySubCategoriesLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}
