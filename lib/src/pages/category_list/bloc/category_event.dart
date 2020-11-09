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

class CategoryListLoaded extends CategoryEvent {
  final String lang;

  CategoryListLoaded({this.lang});

  @override
  List<Object> get props => [lang];
}

class BrandSubCategoriesLoaded extends CategoryEvent {
  final String brandId;
  final String lang;

  BrandSubCategoriesLoaded({this.brandId, this.lang});

  @override
  List<Object> get props => [brandId, lang];
}
