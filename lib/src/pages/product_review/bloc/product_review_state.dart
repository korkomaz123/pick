part of 'product_review_bloc.dart';

abstract class ProductReviewState extends Equatable {
  const ProductReviewState();

  @override
  List<Object> get props => [];
}

class ProductReviewInitial extends ProductReviewState {}

class ProductReviewAddedInProcess extends ProductReviewState {}

class ProductReviewAddedSuccess extends ProductReviewState {}

class ProductReviewAddedFailure extends ProductReviewState {
  final String message;

  ProductReviewAddedFailure({this.message});

  @override
  List<Object> get props => [message];
}
