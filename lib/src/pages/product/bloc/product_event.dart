part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductListLoaded extends ProductEvent {
  final String subCategoryId;
  final String lang;

  ProductListLoaded({this.subCategoryId, this.lang});

  @override
  List<Object> get props => [subCategoryId, lang];
}
