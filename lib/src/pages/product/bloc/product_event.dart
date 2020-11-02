part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductListLoaded extends ProductEvent {
  final String categoryId;
  final String lang;

  ProductListLoaded({this.categoryId, this.lang});

  @override
  List<Object> get props => [categoryId, lang];
}

class ProductListSorted extends ProductEvent {
  final String categoryId;
  final String lang;
  final String sortItem;

  ProductListSorted({this.categoryId, this.lang, this.sortItem});

  @override
  List<Object> get props => [categoryId, lang, sortItem];
}

class ProductListFiltered extends ProductEvent {}
