part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductDetailsLoaded extends ProductEvent {
  final String productId;
  final String lang;

  ProductDetailsLoaded({this.productId, this.lang});

  @override
  List<Object> get props => [productId, lang];
}
