import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/product_model.dart';
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
    if (event is ProductListLoaded) {
      yield* _mapProductListLoadedToState(
        event.categoryId,
        event.lang,
      );
    } else if (event is ProductListSorted) {
      yield* _mapProductListSortedToState(
        event.categoryId,
        event.lang,
        event.sortItem,
      );
    }
  }

  Stream<ProductState> _mapProductListLoadedToState(
    String categoryId,
    String lang,
  ) async* {
    yield ProductListLoadedInProcess();
    try {
      final result = await _productRepository.getProducts(categoryId, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> productList = result['products'];
        List<ProductModel> products = [];
        for (int i = 0; i < productList.length; i++) {
          products.add(ProductModel.fromJson(productList[i]));
        }
        yield ProductListLoadedSuccess(products: products);
      } else {
        yield ProductListLoadedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield ProductListLoadedFailure(message: e.toString());
    }
  }

  Stream<ProductState> _mapProductListSortedToState(
    String categoryId,
    String lang,
    String sortItem,
  ) async* {
    yield ProductListLoadedInProcess();
    try {
      final result =
          await _productRepository.sortProducts(categoryId, sortItem, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> productList = result['products'];
        List<ProductModel> products = [];
        for (int i = 0; i < productList.length; i++) {
          products.add(ProductModel.fromJson(productList[i]));
        }
        yield ProductListLoadedSuccess(products: products);
      } else {
        yield ProductListLoadedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield ProductListLoadedFailure(message: e.toString());
    }
  }
}
