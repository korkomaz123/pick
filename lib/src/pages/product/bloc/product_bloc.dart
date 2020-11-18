import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/review_entity.dart';
import 'package:ciga/src/pages/product/bloc/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({@required ProductRepository productRepository})
      : assert(productRepository != null),
        _productRepository = productRepository,
        super(ProductInitial());

  final ProductRepository _productRepository;

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is ProductDetailsLoaded) {
      yield* _mapProductDetailsLoadedToState(event.productId, event.lang);
    } else if (event is ProductInitialized) {
      yield ProductInitial();
    }
  }

  Stream<ProductState> _mapProductDetailsLoadedToState(
    String productId,
    String lang,
  ) async* {
    yield ProductDetailsLoadedInProcess();
    try {
      final result =
          await _productRepository.getProductDetails(productId, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> reviewList = result['reviews'];
        List<ReviewEntity> reviews = [];
        for (int i = 0; i < reviewList.length; i++) {
          reviews.add(ReviewEntity.fromJson(reviewList[i]));
        }
        result['moreAbout']['reviews'] = reviews;
        final productEntity = ProductEntity.fromJson(result['moreAbout']);
        yield ProductDetailsLoadedSuccess(productEntity: productEntity);
      } else {
        yield ProductDetailsLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield ProductDetailsLoadedFailure(message: e.toString());
    }
  }
}
