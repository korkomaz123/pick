part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductDetailsLoadedInProcess extends ProductState {}

class ProductDetailsLoadedSuccess extends ProductState {
  final ProductEntity productEntity;

  ProductDetailsLoadedSuccess({this.productEntity});

  @override
  List<Object> get props => [productEntity];
}

class ProductDetailsLoadedFailure extends ProductState {
  final String message;

  ProductDetailsLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}
