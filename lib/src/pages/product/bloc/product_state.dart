part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductListLoadedInProcess extends ProductState {}

class ProductListLoadedSuccess extends ProductState {
  final List<ProductModel> products;

  ProductListLoadedSuccess({this.products});

  @override
  List<Object> get props => [products];
}

class ProductListLoadedFailure extends ProductState {
  final String message;

  ProductListLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}
