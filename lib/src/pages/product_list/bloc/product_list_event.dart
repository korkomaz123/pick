part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class ProductListLoaded extends ProductListEvent {
  final String categoryId;
  final String lang;
  final int page;

  ProductListLoaded({this.categoryId, this.lang, this.page});

  @override
  List<Object> get props => [categoryId, lang, page];
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
  final int page;

  BrandProductListLoaded({this.brandId, this.lang, this.categoryId, this.page});

  @override
  List<Object> get props => [brandId, lang, categoryId, page];
}

class ProductListInitialized extends ProductListEvent {}
