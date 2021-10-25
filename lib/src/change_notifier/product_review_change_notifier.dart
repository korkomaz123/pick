import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/review_entity.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

class ProductReviewChangeNotifier extends ChangeNotifier {
  final ProductRepository productRepository = ProductRepository();

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
    String username, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    final isSuccess = await productRepository.addReview(
        productId, title, detail, rate, token, username);
    if (isSuccess) {
      if (onSuccess != null) onSuccess();
      getProductReviews(productId);
    } else {
      if (onFailure != null) onFailure();
    }
  }
}
