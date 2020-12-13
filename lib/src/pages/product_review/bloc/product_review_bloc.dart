import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/pages/product/bloc/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'product_review_event.dart';
part 'product_review_state.dart';

class ProductReviewBloc extends Bloc<ProductReviewEvent, ProductReviewState> {
  ProductReviewBloc({@required ProductRepository productRepository})
      : assert(productRepository != null),
        _productRepository = productRepository,
        super(ProductReviewInitial());

  final ProductRepository _productRepository;

  @override
  Stream<ProductReviewState> mapEventToState(
    ProductReviewEvent event,
  ) async* {
    if (event is ProductReviewAdded) {
      yield* _mapProductReviewAddedToState(
        event.productId,
        event.title,
        event.detail,
        event.rate,
        event.token,
      );
    }
  }

  Stream<ProductReviewState> _mapProductReviewAddedToState(
    String productId,
    String title,
    String detail,
    String rate,
    String token,
  ) async* {
    yield ProductReviewAddedInProcess();
    try {
      await _productRepository.addReview(productId, title, detail, rate, token);
      yield ProductReviewAddedSuccess();
    } catch (e) {
      yield ProductReviewAddedFailure(message: e.toString());
    }
  }
}
