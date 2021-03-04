import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/review_entity.dart';
import 'package:markaa/src/pages/product/bloc/product_repository.dart';

class ProductReviewChangeNotifier extends ChangeNotifier {
  ProductReviewChangeNotifier({this.productRepository});

  final ProductRepository productRepository;

  List<ReviewEntity> reviews = [];

  void initialize() {
    reviews = [];
    notifyListeners();
  }

  void getProductReviews(String productId) async {
    reviews = await productRepository.getProductReviews(productId);
    notifyListeners();
  }

  void addReview(
    String productId,
    String title,
    String detail,
    String rate,
    String token,
    String username,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  ) async {
    onProcess();
    final isSuccess = await productRepository.addReview(
        productId, title, detail, rate, token, username);
    if (isSuccess) {
      onSuccess();
      getProductReviews(productId);
    } else {
      onFailure();
    }
  }
}
