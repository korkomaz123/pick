part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class ProductListLoaded extends ProductListEvent {
  final String categoryId;
  final String lang;

  ProductListLoaded({this.categoryId, this.lang});

  @override
  List<Object> get props => [categoryId, lang];
}

class ProductListSorted extends ProductListEvent {
  final String categoryId;
  final String lang;
  final String sortItem;

  ProductListSorted({this.categoryId, this.lang, this.sortItem});

  @override
  List<Object> get props => [categoryId, lang, sortItem];
}

class ProductListFiltered extends ProductListEvent {}

class BrandProductListLoaded extends ProductListEvent {
  final String brandId;
  final String categoryId;
  final String lang;

  BrandProductListLoaded({this.brandId, this.lang, this.categoryId});

  @override
  List<Object> get props => [brandId, lang, categoryId];
}

class ProductListInitialized extends ProductListEvent {}
