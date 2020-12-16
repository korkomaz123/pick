part of 'product_review_bloc.dart';

abstract class ProductReviewEvent extends Equatable {
  const ProductReviewEvent();

  @override
  List<Object> get props => [];
}

class ProductReviewAdded extends ProductReviewEvent {
  final String productId;
  final String rate;
  final String title;
  final String detail;
  final String token;
  final String username;

  ProductReviewAdded({
    this.productId,
    this.rate,
    this.title,
    this.detail,
    this.token,
    this.username,
  });

  @override
  List<Object> get props => [productId, rate, title, detail, token, username];
}
