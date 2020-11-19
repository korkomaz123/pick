part of 'category_list_bloc.dart';

abstract class CategoryListEvent extends Equatable {
  const CategoryListEvent();

  @override
  List<Object> get props => [];
}

class CategoryListLoaded extends CategoryListEvent {
  final String lang;

  CategoryListLoaded({this.lang});

  @override
  List<Object> get props => [lang];
}
