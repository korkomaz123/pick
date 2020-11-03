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

  ProductListLoadedSuccess({this.products});

  @override
  List<Object> get props => [products];
}

class ProductListLoadedFailure extends ProductListState {
  final String message;

  ProductListLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}
