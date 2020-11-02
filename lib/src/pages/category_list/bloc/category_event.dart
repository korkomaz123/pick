part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategorySubCategoriesLoaded extends CategoryEvent {
  final String categoryId;
  final String lang;

  CategorySubCategoriesLoaded({this.categoryId, this.lang});

  @override
  List<Object> get props => [categoryId, lang];
}
