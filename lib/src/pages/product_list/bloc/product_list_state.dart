part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoadedInProcess extends ProductListState {}

class ProductListLoadedSuccess extends ProductListState {
  final List<ProductModel> products;
  final String categoryId;
  final int page;
  final bool isReachedMax;

  ProductListLoadedSuccess({
    this.products,
    this.categoryId,
    this.page,
    this.isReachedMax,
  });

  @override
  List<Object> get props => [products, categoryId, page, isReachedMax];
}

class ProductListLoadedFailure extends ProductListState {
  final String message;

  ProductListLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}
